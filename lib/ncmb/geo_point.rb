# frozen_string_literal: true

module NCMB
  class GeoPoint
    include NCMB
    
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end
    
    def to_json(a = '')
      {
        '__type': 'GeoPoint',
        'longitude': @longitude,
        'latitude': @latitude
      }.to_json
    end
    
    def to_s
      "GeoPoint (latitude: #{@latitude}, longitude: #{@longitude})"
    end
  end
end