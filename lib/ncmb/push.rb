module NCMB
  class Push
    include NCMB
    attr_accessor :deliveryTime, :immediateDeliveryFlag, :target, :searchCondition, :message,
    :userSettingValue, :deliveryExpirationDate, :deliveryExpirationTime, :action, :title, :dialog,
    :badgeIncrementFlag, :badgeSetting, :sound, :contentAvailable, :richUrl, :acl, :objectId, :createDate, :errors
    
    def save
      path = "/#{@@client.api_version}/push"
      queries = {}
      [:deliveryTime, :immediateDeliveryFlag, :target, :searchCondition, :message,
       :userSettingValue, :deliveryExpirationDate, :deliveryExpirationTime, :action, :title, :dialog,
       :badgeIncrementFlag, :badgeSetting, :sound, :contentAvailable, :richUrl, :acl].each do |name|
        queries[name] = send(name) unless send(name).nil?
      end
      results = @@client.post path, queries
      if results[:objectId].nil?
        self.errors = results
        return false
      end
      self.objectId = results[:objectId]
      self.createDate = results[:createDate]
      return true
    end
  end
end
