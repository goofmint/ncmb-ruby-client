module NCMB
  class Devise < NCMB::DataStore
    attr_accessor :client, :name
    def initialize(client)
      @client = client
      @name   = "Instration"
    end
    
    def push
      return NCMB::Push.new(client)
    end
  end
end
