$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']
@todo = NCMB::DataStore.new 'AA200'
@todo = @todo.limit(20)

@todo.each do |item|
  puts item[:String]
  puts "  #{item[:Array]} -> #{item[:Array].class}"
end

@todo = NCMB::Object.new 'AA200'
@todo.set('String', 'テスト100')
@todo.set('Integer', 100)
@todo.set('Boolean', true)
@todo.set('Array', [1, 2, 3, "Orange", "Tomato"])
@todo.set('Object', {test1: 'a', test2: 'b'})
@todo.set('Location', NCMB::GeoPoint.new(50, 30))
@todo.set('MultipleLine', "test\ntest\n")
@todo.set('Increment', NCMB::Increment.new(2))
@todo.set('Date', Time.new(2016, 2, 24, 12, 30, 45))
@todo.save
# puts "@todo[0].name #{@todo[0].text}"

