module NCMB
  class DataStore
    attr_accessor :client, :name
    def initialize(client, name)
      @client = client
      @name   = name
    end
    
    def get(queries = {})
      path = "/#{@client.api_version}/classes/#{@name}"
      @client.get path, queries
    end
  end
end
