# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize(
  application_key: yaml['application_key'],
  client_key: yaml['client_key']
)

example = NCMB::DataStore.new 'Example'

require 'benchmark'

ary = []
Benchmark.bm 10 do |r|
  r.report 'Save DataStore' do
    100.times do |i|
      item = example.new
      item.set('String', "テスト#{i}00")
      item.set('Integer', i)
      item.set('Boolean', true)
      item.set('Array', [i, i * 2, i * 3, 'Orange', 'Tomato'])
      item.set('Object', { test1: 'a', test2: 'b' })
      item.set('Location', NCMB::GeoPoint.new(30, 50))
      item.set('MultipleLine', "test\ntest\n")
      item.set('Increment', NCMB::Increment.new(i + 1))
      item.set('Date', Time.now)
      item.save
      ary << item.objectId
    end
  end
  r.report 'Delete objects' do
    ary.each do |objectId|
      item = example.new(objectId: objectId)
      item.delete
    end
  end
end
