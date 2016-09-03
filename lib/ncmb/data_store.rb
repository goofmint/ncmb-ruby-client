module NCMB
  class DataStore
    include NCMB
    
    def initialize(name, fields = {}, alc = "")
      @name    = name
      @alc     = alc
      @fields  = fields
      @queries = {}
      @items   = nil
    end
    
    def new *opt
      initialize opt
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
    
    def set(name, value)
      @fields[name] = value
    end
    
    def call(name)
      @fields[name.to_sym] || NoMethodError
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
      return @items.first unless @items.nil?
      get.first
    end
    
    def limit(count)
      @queries[:limit] = count
      self
    end
    
    def count(count)
      @queries[:count] = count
      self
    end
    
    def skip(count)
      @queries[:skip] = count
      self
    end
    
    def where(params = {})
      @queries[:where] = [] unless @queries[:where]
      if params.size == 1
        @queries[:where] << params
      else
        params.each do |hash|
          @queries[:where] << hash
        end
      end
      self
    end
    
    def [](count)
      get[count]
    end
    
    def get
      return @items unless @items.nil?
      path = "/#{@@client.api_version}/classes/#{@name}"
      results = @@client.get path, @queries
      return [] unless results
      if results[:error] && results[:error] != ""
        @error = results
        raise 'error'
      end
      @items = []
      results[:results].each do |result|
        alc = result[:acl]
        result.delete(:acl)
        @items << NCMB::DataStore.new(@name, result, alc)
      end
      @items
    end
    
    def post
      path = "/#{@@client.api_version}/classes/#{@name}"
      result = @@client.post path, @fields
      alc = result[:acl]
      result.delete(:acl)
      NCMB::DataStore.new(@name, result, alc)
    end
    alias :save :post
  end
end
