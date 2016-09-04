$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

@todo = NCMB::DataStore.new 'AA200'
# @todo = @todo.limit(20).where("String", 'テスト100').greaterThan("Integer", 1)
# @todo = @todo.limit(20).notEqualTo("String", 'テスト100')
# @todo = @todo.limit(20).in("String", ['テスト100'])
# @todo = @todo.limit(20).notIn("String", ['テスト100'])
# @todo = @todo.limit(20).inArray("Array", [4])
# @todo = @todo.limit(20).notInArray("Array", ['Orange'])
# @todo = @todo.limit(20).allInArray("Array", [1, 2, 4])

geo1 = NCMB::GeoPoint.new(50, 30);
geo2 = NCMB::GeoPoint.new(51, 31);

# @todo = @todo.limit(20).withinKilometers("Location", geo1, 1000)
@todo = @todo.limit(20).withinSquare("Location", geo1, geo2)
begin
  @todo.each do |item|
    puts item[:String]
    puts "  #{item[:Array]} -> #{item[:Array].class}"
    puts "  #{item[:Location]} -> #{item[:Location].class}"
    puts "  #{item[:Date]} -> #{item[:Date].class}"
  end
rescue NCMB::FetchError => e
  puts @todo.error
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

