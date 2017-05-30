# frozen_string_literal: true

module NCMB
  module Query
    [
      {greaterThan: '$gt'},
      {notEqualTo: '$ne'},
      {equalTo: nil},
      {lessThan: '$lt'},
      {lessThanOrEqualTo: '$lte'},
      {greaterThanOrEqualTo: '$gte'},
      {in: '$in'},
      {notIn: '$nin'},
      {exists: '$exists'},
      {regex: '$regex'},
      {inArray: '$inArray'},
      {notInArray: '$ninArray'},
      {allInArray: '$all'},
    ].each do |m|
      define_method m.keys.first do |name, value|
        params = {}
        if m.values.first.nil?
          params[name] = value
        else
          params[name] = {}
          params[name][m.values.first] = value
        end
        @queries[@search_key] << params
        self
      end
    end

    [
      {withinKilometers: '$maxDistanceInKilometers'},
      {withinMiles: '$maxDistanceInMiles'},
      {withinRadians: '$maxDistanceInRadians'}
    ].each do |m|
      define_method m.keys.first do |name, geo, value|
        params = {}
        params[name] = {
          '$nearSphere': geo,
        }
        params[name][m.values.first] = value
        @queries[@search_key] << params
        self
      end
    end
      
    def withinSquare(name, geo1, geo2)
      params = {}
      params[name] = {
        '$within': {
          '$box': [
            geo1,
            geo2
          ]
        }
      }
      @queries[@search_key] << params
      self
    end

    def where(name, value)
      params = {}
      params[name] = value
      @queries[@search_key] << params
      self
    end
  end
end
