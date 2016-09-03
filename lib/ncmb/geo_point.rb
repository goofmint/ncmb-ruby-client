module NCMB
  class GeoPoint
    include NCMB
    
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end
    
    def to_json(a)
      "{\"__type\": \"GeoPoint\", \"longitude\": #{@longitude}, \"latitude\": #{@latitude}}"
    end
  end
end