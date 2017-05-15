# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'time'
require 'openssl'
require 'base64'
require 'net/http'
require 'uri'
require 'erb'
require 'json'
require 'securerandom'

require 'ncmb/version'
require 'ncmb/client'
require 'ncmb/query'
require 'ncmb/data_store'
require 'ncmb/object'
require 'ncmb/file'
require 'ncmb/user'
require 'ncmb/push'
require 'ncmb/geo_point'
require 'ncmb/increment'
require 'ncmb/acl'
require 'ncmb/role'
require 'ncmb/relation'
require 'ncmb/error'
