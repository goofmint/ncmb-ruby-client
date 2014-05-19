require 'time'
require 'openssl'
require 'Base64'
require "net/http"
require "uri"
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
    
    def request(method, path, queries = {})
      encoded_queries = {}
      queries.each do |k, v|
        encoded_queries[URI.encode(k.to_s)] = URI.encode(v.to_s)
      end
      params_base = {
        "SignatureMethod" => "HmacSHA256",
        "SignatureVersion" => "2",
        "X-NCMB-Application-Key" => @application_key
      }
      params = params_base.merge(encoded_queries)
      now = Time.now.utc.iso8601
      params = params.merge "X-NCMB-Timestamp" => now
      params = Hash[params.sort{|a, b| a[0].to_s <=> b[0].to_s}]
      query = encoded_queries.collect{|k,v| "#{k}=#{v}"}.join('&')

      signature_base = []
      signature_base << method.upcase
      signature_base << @domain
      signature_base << path
      signature_base << params.collect{|k,v| "#{k}=#{v}"}.join("&")
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), @client_key, signature_base.join("\n"))).strip()

      http = Net::HTTP.new(@domain, 443)
      http.use_ssl=true
      headers = {
        "X-NCMB-Application-Key" => params_base["X-NCMB-Application-Key"], 
        "X-NCMB-Signature" => signature,
        "X-NCMB-Timestamp" => now,
        "Content-Type" => 'application/json'
      }
      path = path + (query == '' ? "" : "?"+query)
      if method == :get
        return http.get(path, headers).body
      else
        return http.post(path, headers).body
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
