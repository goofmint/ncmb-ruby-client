module NCMB
  class Acl < NCMB::Object
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
    
    def public(read_or_write, value = true)
      @fields['*'.to_sym][read_or_write.to_sym] = value
    end
    
    def user(user, read_or_write, value = true)
      @fields[user.objectId.to_sym] = {read: true, write: true} unless @fields[user.objectId.to_sym]
      @fields[user.objectId.to_sym][read_or_write.to_sym] = value
    end
    
    def role(role, read_or_write, value = true)
      @fields[role.name.to_sym] = {read: true, write: true} unless @fields[role.name.to_sym]
      @fields[role.name.to_sym][read_or_write.to_sym] = value
    end
  end
end
