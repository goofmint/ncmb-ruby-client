module NCMB
  class DataStore
    include NCMB
    
    def initialize(name, fields = {}, alc = "")
      @name    = name
      @alc     = alc
      @fields  = fields
      @queries = {where: []}
      @items   = nil
    end
    
    def error
      @error
    end
    
    def new opt = {}
      NCMB::Object.new @name, opt
    end
    
    def columns
      @fields.keys
    end
    
    def method_missing(name)
      if @fields[name.to_sym]
        return @fields[name.to_sym]
      else
        raise NoMethodError, "#{name} is not found"
      end
    end
    
    def each(&block)
      get.each(&block)
    end
    
    def each_with_index(&block)
      get.each_with_index(&block)
    end
    
    def order(field)
      @queries[:order] = field
      self
    end
    
    def first
      get.first
    end
    
    def limit(count)
      @queries[:limit] = count
      self
    end
    
    def count
      @queries[:count] = 1
      self
    end
    
    def skip(count)
      @queries[:skip] = count
      self
    end
    
    [
      {greaterThan: "$gt"},
      {notEqualTo: "$ne"},
      {equalTo: nil},
      {lessThan: "$lt"},
      {lessThanOrEqualTo: "$lte"},
      {greaterThanOrEqualTo: "$gte"},
      {in: "$in"},
      {notIn: "$nin"},
      {exists: "$exists"},
      {regex: "$regex"},
      {inArray: "$inArray"},
      {notInArray: "$ninArray"},
      {allInArray: "$all"},
    ].each do |m|
      define_method m.keys.first do |name, value|
        params = {}
        if m.values.first.nil?
          params[name] = value
        else
          params[name] = {}
          params[name][m.values.first] = value
        end
        @queries[:where] << params
        self
      end
    end
    
    [
      {withinKilometers: "$maxDistanceInKilometers"},
      {withinMiles: "$maxDistanceInMiles"},
      {withinRadians: "$maxDistanceInRadians"}
    ].each do |m|
      define_method m.keys.first do |name, geo, value|
        params = {}
        params[name] = {
          "$nearSphere": geo,
        }
        params[name][m.values.first] = value
        @queries[:where] << params
        self
      end
    end
      
    def withinSquare(name, geo1, geo2)
      params = {}
      params[name] = {
        "$within": {
          "$box": [
            geo1,
            geo2
          ]
        }
      }
      @queries[:where] << params
      self
    end
    
    def where(name, value)
      params = {}
      params[name] = value
      @queries[:where] << params
      self
    end
    
    def [](count)
      get[count]
    end
    
    def get
      return @items unless @items.nil?
      path = "/#{@@client.api_version}/classes/#{@name}"
      results = @@client.get path, @queries
      return [] unless results
      if results[:error] && results[:error] != ""
        @error = results
        raise NCMB::FetchError
      end
      if @queries[:count] == 1
        return results[:count]
      end
      @items = []
      results[:results].each do |result|
        result.each do |key, field|
          if field.is_a?(Hash) && field[:__type] == 'GeoPoint'
            result[key] = NCMB::GeoPoint.new(field[:latitude], field[:longitude])
          end
          if field.is_a?(Hash) && field[:__type] == 'Date'
            result[key] = Time.parse(field[:iso])
          end
        end
        alc = result[:acl]
        result.delete(:acl)
        @items << NCMB::Object.new(@name, result, alc)
      end
      @items
    end
    
    def delete_all
      max = 1000
      count = self.limit(max).count().get
      if count == 0
        return true
      end
      @queries.delete :count
      self.limit(max).each do |item|
        item.delete
      end
      if count > max
        return delete_all
      end
      true
    end
  end
end
