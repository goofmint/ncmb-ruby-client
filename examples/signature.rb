# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
@client = NCMB.initialize(
  application_key: yaml['application_key'],
  client_key: yaml['client_key']
)

# puts @client.application_key
puts @client.generate_signature(:get, 
  '/2013-09-01/classes/TestClass',
  '2013-12-02T02:44:35.452Z',
  {
    where: {
      testKey: 'testValue'
    }
  }
)

