module NCMB
  class NFile < NCMB::Object
    include NCMB
    def initialize(file_path = nil)
      @fields = {acl: NCMB::Acl.new, file: file_path}
      if file_path
        @fileName = File.basename(file_path)
      end
    end
    
    def save
      @fields[:file] = open(self.file)
      @fields[:fileName] = @filename
      super
    end
    
    def path
      "#{base_path}/#{@fileName}"
    end
    
    def base_path
      path = "/#{@@client.api_version}/files"
    end
  end
end