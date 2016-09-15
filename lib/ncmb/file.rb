require 'mime/types'
module NCMB
  class NFile < NCMB::Object
    include NCMB
    def initialize(file_path = nil)
      @fields = {acl: NCMB::Acl.new, file: file_path}
      if file_path
        @fields[:fileName] = File.basename(file_path)
        @fields['mime-type'.to_sym] = MIME::Types.type_for(file_path)[0]
      end
    end
    
    def save
      @fields[:file] = open(self.file)
      super
    end
    alias :update :save
    
    def path
      "#{base_path}/#{@fields[:fileName]}"
    end
    
    def base_path
      "/#{@@client.api_version}/files"
    end
  end
end