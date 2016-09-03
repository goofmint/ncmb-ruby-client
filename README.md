ncmb-ruby-client
================

A simple Ruby client for the nifty cloud mobile backend REST API

Basic Usage
-----------

```
NCMB.initialize application_key: application_key,  client_key: client_key

@todo = NCMB::DataStore.new 'Todo'
@todo = @todo.limit(20)

@todo.each do |item|
  puts item[:String]
  puts "  #{item[:Array]} -> #{item[:Array].class}"
end

@todo = NCMB::Object.new 'Todo'
@todo.set('String', 'Test String')
@todo.set('Integer', 100)
@todo.set('Boolean', true)
@todo.set('Array', [1, 2, 3, "Orange", "Tomato"])
@todo.set('Object', {test1: 'a', test2: 'b'})
@todo.set('Location', NCMB::GeoPoint.new(50, 30))
@todo.set('MultipleLine', "test\ntest\n")
@todo.set('Increment', NCMB::Increment.new(2))
@todo.set('Date', Time.new(2016, 2, 24, 12, 30, 45))
@todo.save
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
