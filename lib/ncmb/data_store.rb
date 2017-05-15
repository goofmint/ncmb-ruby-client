# frozen_string_literal: true

module NCMB
  class DataStore
    include NCMB
    
    include NCMB::Query
    
    def initialize(name, fields = {}, alc = "")
      @name    = name
      @alc     = alc
      @fields  = fields
      @search_key = :where
      @queries = {}
      @queries[@search_key] = []
      @items   = nil
      @path    = nil
    end
    attr_accessor :path
    
    def error
      @error
    end
    
    def new opt = {}
      NCMB::Object.new @name, opt
    end
    
    def columns
      @fields.keys
    end
    
    def method_missing(name)
      if @fields[name.to_sym]
        return @fields[name.to_sym]
      else
        raise NoMethodError, "#{name} is not found"
      end
    end
    
    def each(&block)
      get.each(&block)
    end
    
    def each_with_index(&block)
      get.each_with_index(&block)
    end
    
    def order(field)
      @queries[:order] = field
      self
    end
    
    def first
      get.first
    end
    
    def limit(count)
      @queries[:limit] = count
      self
    end
    
    def count
      @queries[:count] = 1
      self
    end
    
    def skip(count)
      @queries[:skip] = count
      self
    end
    
    def [](count)
      get[count]
    end
    
    def path
      return @path if @path
      if ["file", "user", "push", "installation"].include? @name
        if @name == "push"
          "/#{@@client.api_version}/#{@name}"
        else
          "/#{@@client.api_version}/#{@name}s"
        end
      else
        "/#{@@client.api_version}/classes/#{@name}"
      end
    end
    
    def get
      # return @items unless @items.nil?
      results = @@client.get path, @queries
      return [] unless results
      if results[:error] && results[:error] != ""
        @error = results
        raise NCMB::FetchError
      end
      if @queries[:count] == 1
        return results[:count]
      end
      @items = []
      results[:results].each do |result|
        result.each do |key, field|
          if field.is_a?(Hash) && field[:__type] == 'GeoPoint'
            result[key] = NCMB::GeoPoint.new(field[:latitude], field[:longitude])
          end
          if field.is_a?(Hash) && field[:__type] == 'Date'
            result[key] = Time.parse(field[:iso])
          end
        end
        @items << NCMB::Object.new(@name, result)
      end
      @items
    end
    alias :all :get
    
    def queries
      @queries
    end
    
    def delete_all
      max = 1000
      dataStore = NCMB::DataStore.new(@name)
      count = dataStore.limit(max).count().all
      if count == 0
        return true
      end
      dataStore.queries.delete :count
      dataStore.each do |item|
        begin
          item.delete if item.deletable?
        rescue
          puts "Can't delete #{item.objectId}"
        end
      end
      if count > max
        return delete_all
      end
      true
    end
  end
end
