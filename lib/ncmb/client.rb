require 'time'
require 'openssl'
require 'Base64'
require "net/http"
require "uri"
require 'json'
module NCMB
  DOMAIN = 'mb.api.cloud.nifty.com'
  API_VERSION = '2013-09-01'
  class Client
    attr_accessor :application_key, :client_key, :domain, :api_version
    def initialize(params = {})
      @domain          = NCMB::DOMAIN
      @api_version     = NCMB::API_VERSION
      @application_key = params[:application_key]
      @client_key      = params[:client_key]
    end
    
    def data_store(name)
      NCMB::DataStore.new self, name
    end
    
    def get(path, params)
      request :get, path, params
    end
    
    def post(path, params)
      request :post, path, params
    end
    
    def encode_query(queries = {})
      queries.each do |k, v|
        if v.is_a? Hash
          queries[k] = URI.escape(v.to_json.to_s, /[^-_.!~*'()a-zA-Z\d;\/?:@&=+$,#]/)
        else
          queries[k] = URI.escape(v.to_s, /[^-_.!~*'()a-zA-Z\d;\/?:@&=+$,#]/)
        end
      end
      queries
    end
    
    def generate_signature(method, path, now = nil, queries = {})
      params_base = {
        "SignatureMethod" => "HmacSHA256",
        "SignatureVersion" => "2",
        "X-NCMB-Application-Key" => @application_key
      }
      params = method == :get ? params_base.merge(encode_query(queries)) : params_base
      now ||= Time.now.utc.iso8601
      params = params.merge "X-NCMB-Timestamp" => now
      params = Hash[params.sort{|a, b| a[0].to_s <=> b[0].to_s}]
      signature_base = []
      signature_base << method.upcase
      signature_base << @domain
      signature_base << path
      signature_base << params.collect{|k,v| "#{k}=#{v}"}.join("&")
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), @client_key, signature_base.join("\n"))).strip()
    end
    
    def request(method, path, queries = {})
      now = Time.now.utc.iso8601
      signature = generate_signature(method, path, now, queries)
      query = queries.collect{|k,v| "#{k}=#{v.is_a?(Hash) ? v.to_json.to_s : v}"}.join("&")
      http = Net::HTTP.new(@domain, 443)
      http.use_ssl=true
      headers = {
        "X-NCMB-Application-Key" => @application_key,
        "X-NCMB-Signature" => signature,
        "X-NCMB-Timestamp" => now,
        "Content-Type" => 'application/json'
      }
      if method == :get
        path = path + (query == '' ? "" : "?"+query)
        return http.get(path, headers).body
      else
        return http.post(path, queries.to_json, headers)
      end
    end
  end
  
  @@client = nil
  def NCMB.init(params = {})
    defaulted = {
      application_key: ENV["NCMB_APPLICATION_KEY"],
      client_key:      ENV["NCMB_CLIENT_KEY"]
    }
    defaulted.merge!(params)
    @@client = Client.new(defaulted)
  end
end
