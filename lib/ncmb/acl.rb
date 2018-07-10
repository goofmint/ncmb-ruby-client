# frozen_string_literal: true

module NCMB
  class Acl
    include NCMB
    
    def initialize(params = nil)
      @fields = {'*': {
          read: true,
          write: true
        }
      }
      if params
        @fields = @fields.merge(params)
      end
    end
    
    def to_json(a = "")
      params = {}
      @fields.each do |key, value|
        params[key.to_sym] = {} if value[:read] || value[:write]
        [:read, :write].each do |name|
          params[key.to_sym][name] = true if value[name]
        end
      end
      params.to_json
    end
    
    def public(read_or_write, bol = true)
      @fields['*'.to_sym][read_or_write.to_sym] = bol
    end
    
    # :reek:DuplicateMethodCall { max_calls: 2 }
    def user(user, read_or_write, value = true)
      @fields[user.objectId.to_sym] = {read: true, write: true} unless @fields[user.objectId.to_sym]
      @fields[user.objectId.to_sym][read_or_write.to_sym] = value
    end
    
    # :reek:DuplicateMethodCall { max_calls: 2 }
    def role(role, read_or_write, value = true)
      @fields[role.name.to_sym] = {read: true, write: true} unless @fields[role.name.to_sym]
      @fields[role.name.to_sym][read_or_write.to_sym] = value
    end
  end
end
