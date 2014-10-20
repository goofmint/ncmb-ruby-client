ncmb-ruby-client
================

A simple Ruby client for the nifty cloud mobile backend REST API

Basic Usage
-----------

```
NCMB.initialize application_key: application_key,  client_key: client_key

@todo = NCMB::DataStore.new 'Todo'
@todo = @todo.limit(20).count(1).skip(0)
puts "@todo[0].name #{@todo[0].name}"
```

### Register push notification

```
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
