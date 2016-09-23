$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

Food = NCMB::DataStore.new 'Food'

Basket = NCMB::DataStore.new('Basket')
basket = Basket.new
basket.foods = []
basket.foods << Food.new(name: "banana", type: "fruit")
basket.foods << Food.new(name: "pear", type: "fruit")

# relation = NCMB::Relation.new
# relation << Food.new(name: "banana", type: "fruit", objectId: "test1")
# relation << Food.new(name: "pear", type: "fruit", objectId: "test2")

# puts basket.fields
basket.save
