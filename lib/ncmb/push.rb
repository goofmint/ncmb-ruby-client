# frozen_string_literal: true

module NCMB
  class Push < NCMB::Object
    include NCMB
    
    def initialize(params = {})
      [:deliveryTime, :immediateDeliveryFlag, :target, :searchCondition, :message,
      :userSettingValue, :deliveryExpirationDate, :deliveryExpirationTime, :action, :title, :dialog,
      :badgeIncrementFlag, :badgeSetting, :sound, :contentAvailable, :richUrl].each do |name|
        params[name] = nil unless params[name]
      end
      @search_key = :search_condition
      @queries = {}
      @queries[@search_key] = []
      super('push', params)
    end
    
    def base_path
      "/#{@@client.api_version}/#{@name}"
    end
    
  end
end
