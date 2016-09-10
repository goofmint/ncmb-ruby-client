$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

example = NCMB::DataStore.new 'Example'
example.delete_all

9.times do |i|
  item = example.new
  item.set('String', "テスト#{i}00")
  item.set('Integer', i)
  item.set('Boolean', true)
  item.set('Array', [i, i * 2, i * 3, "Orange", "Tomato"])
  item.set('Object', {test1: 'a', test2: 'b'})
  item.set('Location', NCMB::GeoPoint.new((i + 1) * 10, (i + 2) * 5))
  item.set('MultipleLine', "test\ntest\n")
  item.set('Increment', NCMB::Increment.new(i + 1))
  item.set('Date', Time.now)
  item.save
  sleep(2)
end

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
example = example.limit(1).withinSquare("Location", geo1, geo2)
begin
  example.each_with_index do |item, i|
    puts item[:String]
    puts "  #{item[:Array]} -> #{item[:Array].class}"
    puts "  #{item[:Location]} -> #{item[:Location].class}"
    puts "  #{item[:Date]} -> #{item[:Date].class}"
    item.set('Increment', NCMB::Increment.new(i + 1))
    item.update
    # item.set('String', 'テスト200')
    # item.update
  end
rescue NCMB::FetchError => e
  puts example.error
end

# puts "@todo[0].name #{@todo[0].text}"

