module NCMB
  class DataStore
    include NCMB
    
    def initialize(name, fields = {}, alc = "")
      @@name    = name
      @@alc     = alc
      @@fields  = fields
      @@queries = {}
      @@items   = nil
    end
    
    def columns
      @@fields.keys
    end
    
    def method_missing(name)
      if @@fields[name.to_sym]
        return @@fields[name.to_sym]
      else
        raise NoMethod, "#{name} is not found"
      end
    end
    
    def call(name)
      @@fields[name.to_sym] || NoMethod
    end
    
    def each(&block)
      (@@items || get(@@queries)).each(&block)
    end
    
    def each_with_index(&block)
      (@@items || get(@@queries)).each_with_index(&block)
    end
    
    def order(field)
      @@queries[:order] = field
      self
    end
    
    def first
      return @@items.first unless @@items.nil?
      get().first
    end
    
    def limit(count)
      @@queries[:limit] = count
      self
    end
    
    def count(count)
      @@queries[:count] = count
      self
    end
    
    def skip(count)
      @@queries[:skip] = count
      self
    end
    
    def where(params = {})
      @@queries[:where] = [] unless @@queries[:where]
      if params.size == 1
        @@queries[:where] << params
      else
        params.each do |hash|
          @@queries[:where] << hash
        end
      end
      self
    end
    
    def [](count)
      return @@items[count] unless @@items.nil?
      get()[count]
    end
    
    def get(queries = @@queries)
      path = "/#{@@client.api_version}/classes/#{@@name}"
      results = @@client.get path, queries
      return [] unless results
      if results[:error] && results[:error] != ""
        @@error = results
        raise 'error'
      end
      items = []
      results[:results].each do |result|
        alc = result[:acl]
        result.delete(:acl)
        items << NCMB::DataStore.new(@@name, result, alc)
      end
      @@items = items
    end
    
    def post(queries = {})
      path = "/#{@client.api_version}/classes/#{@@name}"
      result = @client.post path, queries
      NCMB::DataStore.new(client, name, result)
    end
  end
end
