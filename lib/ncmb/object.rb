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
        raise NoMethod, "#{name} is not found"
      end
    end

    def [](key)
      @fields[key]
    end

    def delete
      path = "/#{@@client.api_version}/classes/#{@name}/#{@fields[:objectId]}"
      @@client.delete path, {}
    end
  end
end
