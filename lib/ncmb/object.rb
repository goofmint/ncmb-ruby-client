# frozen_string_literal: true

module NCMB
  class Object
    include NCMB

    def initialize(name, fields = {})
      @name    = name
      fields[:acl] = NCMB::Acl.new(fields[:acl])
      @fields  = fields
    end
    
    def fields
      @fields
    end
    
    def ClassName
      @name
    end
    
    def method_missing(name, value = nil)
      if name =~ /.*=$/
        sym = name.to_s.gsub(/(.*?)=$/, '\1').to_sym
        @fields[sym] = value
      else
        sym = name.to_sym
        if @fields.has_key?(sym)
          return @fields[sym]
        else
          raise NoMethodError, "#{name} is not found"
        end
      end
    end

    def set(name, value)
      @fields[name.to_sym] = value
    end
    
    def call(name)
      @fields[name.to_sym] || NoMethodError
    end
    
    def [](key)
      @fields[key]
    end
    
    def deletable?
      if self.acl['*'.to_sym][:write] == true
        return true
      end
      return false unless NCMB.CurrentUser
      return false unless self.acl[NCMB.CurrentUser.objectId.to_sym]
      return false unless self.acl[NCMB.CurrentUser.objectId.to_sym][:write]
      true
    end
    
    def base_path
      "/#{@@client.api_version}/classes/#{@name}"
    end
    
    def path
      "#{base_path}/#{@fields[:objectId] || '' }"
    end
    
    def saved?
      @fields[:objectId] != nil
    end
    
    def convert_params
      @fields.each do |key, field|
        if field.is_a?(NCMB::Object)
          field.save unless field.saved?
          @fields[key] = {
            __type: 'Pointer',
            className: field.ClassName,
            objectId: field.objectId
          }
        end
        if field.is_a?(Array) && field[0].is_a?(NCMB::Object)
          relation = NCMB::Relation.new
          field.each do |sub_field|
            sub_field.save unless sub_field.saved?
            relation << sub_field
          end
          @fields[key] = relation
        end
      end
    end
    
    def post
      return self.put if saved?
      convert_params
      result = @@client.post path, @fields
      @fields.merge!(result)
      self
    end
    alias :save :post
    
    def put
      return self.post unless saved?
      convert_params
      put_path = path
      params = @fields
      params.delete :objectId
      params.delete :createDate
      params.delete :updateDate
      result = @@client.put put_path, params
      @fields[:updateDate] = result[:updateDate]
      self
    end
    alias :update :put
    
    def delete
      response = @@client.delete path, {}
      if response == true
        return true
      else
        @@last_error = response
        return false
      end
    end
    
    def error
      @@last_error
    end
  end
end
