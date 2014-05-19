ncmb-ruby-client
================

A simple Ruby client for the nifty cloud mobile backend REST API


Basic Usage
-----------

```
@ncmb = NCMB.init(application_key: application_key, 
                  client_key: client_key
                  )
queries = {:count => "1", :limit => "20", :order => "-createDate", :skip => "0"}
todo_class = @ncmb.data_store 'TODO'
todo_class.get queries
```
