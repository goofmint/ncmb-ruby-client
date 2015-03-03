ncmb-ruby
================

Forked version of [ncmb-ruby-client](https://github.com/moongift/ncmb-ruby-client), a simple Ruby client for the nifty cloud mobile backend REST API.

Changes Made
------------
* 03/03/2015 - Added PUT and DELETE

Installation
------------
``` ruby
gem 'ncmb-ruby'
```

Basic Usage
-----------

### Client
``` ruby
require 'ncmb'

@client = NCMB.initialize application_key: application_key,  client_key: client_key

# POST data to test table
@client.request :post, "/2013-09-01/classes/test", {message: 'hello world'}

# GET data from test table
@client.request :get, "/2013-09-01/classes/test", {where: {message: 'hello world'}}

# PUT or update data in test table, assuming :objectId = SG8QsGCOVXxgOoPW
@client.request :put, "/2013-09-01/classes/test/SG8QsGCOVXxgOoPW", {message: 'good day'}

# DELETE data in test table, assuming :objectId = SG8QsGCOVXxgOoPW
@client.request :delete, "/2013-09-01/classes/test/SG8QsGCOVXxgOoPW"
```

### Data Store

``` ruby
NCMB.initialize application_key: application_key,  client_key: client_key

@todo = NCMB::DataStore.new 'Todo'
@todo = @todo.limit(20).count(1).skip(0)
puts "@todo[0].name #{@todo[0].name}"
```

### Register push notification

``` ruby
NCMB.initialize application_key: application_key,  client_key: client_key

@push = NCMB::Push.new
@push.immediateDeliveryFlag = true
@push.target = ['ios']
@push.message = "This is test message"
@push.deliveryExpirationTime = "3 day"
if @push.save
  puts "Push save successful."
else
  puts "Push save faild."
end
```

[ニフティクラウド mobile backend](http://mb.cloud.nifty.com/)
