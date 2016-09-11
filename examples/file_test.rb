$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
require 'open-uri'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

f = NCMB::NFile.new('http://mb.cloud.nifty.com/assets/images/logo.png')
f.save()
puts f