$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
@client = NCMB.initialize application_key: "6145f91061916580c742f806bab67649d10f45920246ff459404c46f00ff3e56",  client_key: "1343d198b510a0315db1c03f3aa0e32418b7a743f8e4b47cbff670601345cf75"

# puts @client.application_key
puts @client.generate_signature :get, "/2013-09-01/classes/TestClass", "2013-12-02T02:44:35.452Z", {where: {testKey: "testValue"}}

