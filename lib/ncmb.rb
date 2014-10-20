$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require "ncmb/version"
require "ncmb/client"
require "ncmb/data_store"
require "ncmb/push"
