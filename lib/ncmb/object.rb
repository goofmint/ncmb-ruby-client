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
      alc = result[:acl]
      result.delete(:acl)
      NCMB::Object.new(@name, result, alc)
    end
    alias :save :post
    
    def delete
      path = "/#{@@client.api_version}/classes/#{@name}/#{@fields[:objectId]}"
      @@client.delete path, {}
    end
  end
end
