# frozen_string_literal: true

module NCMB
  class Increment
    include NCMB
    
    def initialize(amount = 1)
      @amount = amount
    end
    
    def to_json(a)
      "{\"__op\": \"Increment\", \"amount\": #{@amount}}"
    end
    
    def amount
      @amount
    end
  end
end