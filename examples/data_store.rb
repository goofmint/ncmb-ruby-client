$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']
@todo = NCMB::DataStore.new 'Todo'
@todo = @todo.limit(20).count(1).skip(0)
# @todo = @todo.where(testKey: "testValue")
# puts "@todo[0] #{@todo[0]}"
puts "@todo[0].name #{@todo[0].name}"

