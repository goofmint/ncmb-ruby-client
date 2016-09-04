module NCMB
  
  class Query
    include NCMB
    def initialize(sql)
      @sql = sql
    end
    
    def to_hash
      ast = PgQuery.parse("SELECT * FROM test WHERE #{@sql}")
      query = ast['whereClause']
      puts query
      make_query(query)
    end
    
    def make_query(query)
      
    end
  end
end