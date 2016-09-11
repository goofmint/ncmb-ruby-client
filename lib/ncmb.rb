$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))

require 'time'
require 'openssl'
require 'base64'
require "net/http"
require "uri"
require "erb"
require "json"

require "ncmb/version"
require "ncmb/client"
require "ncmb/query"
require "ncmb/data_store"
require "ncmb/object"
require "ncmb/file"
require "ncmb/user"
require "ncmb/push"
require "ncmb/geo_point"
require "ncmb/increment"
require "ncmb/acl"
require "ncmb/role"
require "ncmb/error"
