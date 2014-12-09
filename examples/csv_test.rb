$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
require 'csv'

yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']
@todo = NCMB::DataStore.new 'TestClass'
@todos = @todo.limit(20).count(1).skip(0)

csv_string = CSV.generate do |csv|
  csv << @todos.first.columns
  @todos.each_with_index do |todo, i|
    params = []
    todo.columns.each do |name|
      params << todo.call(name)
    end
    csv << params
  end
end

puts csv_string

