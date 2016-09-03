require 'time'
require 'openssl'
require 'base64'
require "net/http"
require "uri"
require "json"

class Time
  def to_json(a)
    v = self.getgm
    "{\"__type\": \"Date\", \"iso\": \"#{v.iso8601(3)}\"}"
  end
end

module NCMB
  DOMAIN = 'mb.api.cloud.nifty.com'
  API_VERSION = '2013-09-01'
  @application_key = nil
  @client_key = nil
  @@client = nil
  
  class Client
    include NCMB
    attr_accessor :application_key, :client_key, :domain, :api_version
    def initialize(params = {})
      @domain          = NCMB::DOMAIN
      @api_version     = NCMB::API_VERSION
      @application_key = params[:application_key]
      @client_key      = params[:client_key]
    end
    
    def get(path, params)
      request :get, path, params
    end
    
    def post(path, params)
      request :post, path, params
    end
    
    def array2hash(ary)
      new_v = {}
      ary.each do |hash|
        if hash.is_a? Hash
          key = hash.keys[0]
          new_v[key] = hash[key]
        else
          new_v = [hash]
        end
      end
      new_v
    end
    
    def encode_query(queries = {})
      results = {}
      queries.each do |k, v|
        v = array2hash(v) if v.is_a? Array
        if v.is_a? Hash
          results[k.to_s] = URI.escape(v.to_json.to_s, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,#]/)
        else
          results[k.to_s] = URI.escape(v.to_s, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,#]/)
        end
      end
      results
    end
    
    def change_query(queries = {})
      results = {}
      queries.each do |k, v|
        case v
        when NCMB::Increment
          queries[k] = v.amount
        end
      end
      queries
    end
    
    def hash2query(queries = {})
      results = {}
      queries.each do |k, v|
        # v = array2hash(v) if v.is_a? Array
        puts "#{k} -> #{v.class}"
        case v
        when Hash, TrueClass, FalseClass, Array then
          results[k.to_s] = v
        when Time then
        else
          results[k.to_s] = v.to_s
        end
      end
      puts results
      results
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
      params = params.sort_by{|a, b| a.to_s}.to_h
      signature_base = []
      signature_base << method.upcase
      signature_base << @domain
      signature_base << path
      signature_base << params.collect{|k,v| "#{k}=#{v}"}.join("&")
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @client_key, signature_base.join("\n"))).strip()
    end
    
    def request(method, path, queries = {})
      now = Time.now.utc.iso8601
      signature = generate_signature(method, path, now, queries)
      http = Net::HTTP.new(@domain, 443)
      http.use_ssl=true
      headers = {
        "X-NCMB-Application-Key" => @application_key,
        "X-NCMB-Signature" => signature,
        "X-NCMB-Timestamp" => now,
        "Content-Type" => 'application/json'
      }
      # queries = hash2query(queries)
      case method
      when :get
        query = queries.map do |key, value|
          "#{key}=#{value}"
        end.join("&")
        path = path + URI.escape((query == '' ? "" : "?"+query), /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,#]/)
        return JSON.parse(http.get(path, headers).body, symbolize_names: true)
      when :post
        queries = change_query(queries)
        return JSON.parse(http.post(path, queries.to_json, headers).body, symbolize_names: true)
      end
    end
  end
  
  def NCMB.initialize(params = {})
    defaulted = {
      application_key: ENV["NCMB_APPLICATION_KEY"],
      client_key:      ENV["NCMB_CLIENT_KEY"]
    }
    defaulted.merge!(params)
    @@client = Client.new(defaulted)
  end
end
