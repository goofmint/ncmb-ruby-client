# frozen_string_literal: true

module NCMB
  class Role < NCMB::Object
    include NCMB
    
    def initialize(name)
      if name.is_a? Hash
        @fields = name
      else
        @fields = {
          roleName: name
        }
      end
      @fields[:acl] = NCMB::Acl.new(@fields[:acl])
    end
    
    def self.find_or_create(name)
      d = NCMB::DataStore.new('role')
      d.path = NCMB::Role.new(name).base_path
      role = d.where('roleName', name).limit(1).get.first
      role ? NCMB::Role.new(role.fields) : NCMB::Role.new(name).save()
    end
    
    def name
      "role:#{@fields[:roleName]}"
    end
    
    def base_path
      path = "/#{@@client.api_version}/roles"
    end
  end
end
