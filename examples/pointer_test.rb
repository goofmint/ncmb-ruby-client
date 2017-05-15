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

Parent = NCMB::DataStore.new 'Parent'

Child = NCMB::DataStore.new 'Child'
child = Child.new(name: 'Taro')
parent = Parent.new(name: 'Oya')
parent.child = child
parent.save

