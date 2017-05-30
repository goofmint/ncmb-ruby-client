# frozen_string_literal: true

module NCMB
  class Relation < Array
    include NCMB
    
    def initialize
      
    end
    
    def to_json(a = '')
      params = {
        '__op': 'AddRelation'
      }
      params['objects'] = []
      self.each do |obj|
        params['objects'] << {
          '__type': 'Pointer',
          'className': obj.ClassName,
          'objectId': obj.objectId
        }
      end
      params.to_json
    end
  end
end