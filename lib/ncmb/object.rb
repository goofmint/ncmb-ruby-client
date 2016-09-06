module NCMB
  class Object
    include NCMB

    def initialize(name, fields = {}, alc = "")
      @name    = name
      @alc     = alc
      @fields  = fields
    end

    def method_missing(name)
      sym = name.to_sym
      if @fields.has_key?(sym)
        return @fields[sym]
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
    
    def [](key)
      @fields[key]
    end

    def post
      path = "/#{@@client.api_version}/classes/#{@name}"
      result = @@client.post path, @fields
      @fields.merge!(result)
      self
    end
    alias :save :post
    
    def put
      path = "/#{@@client.api_version}/classes/#{@name}/#{@fields[:objectId]}"
      params = @fields
      params.delete :objectId
      params.delete :createDate
      params.delete :updateDate
      result = @@client.put path, params
      @fields[:updateDate] = result[:updateDate]
      self
    end
    alias :update :put
    
    def delete
      path = "/#{@@client.api_version}/classes/#{@name}/#{@fields[:objectId]}"
      response = @@client.delete path, {}
      if response == true
        return true
      else
        @error = response
        return false
      end
    end
    
    def error
      @error
    end
  end
end
