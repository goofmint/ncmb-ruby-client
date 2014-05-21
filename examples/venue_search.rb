# -*- coding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
@ncmb = NCMB.init(application_key: yaml['application_key'], 
                  client_key: yaml['client_key']
                  )
json = JSON.parse(open(File.join(File.dirname(__FILE__), 'venues.json'), 'r').read)
venues_class = @ncmb.data_store 'Venues'
json['response']['venues'].each do |venue|
  params = {
    name: venue['name'],
    location: {
      "__type" => "GeoPoint",
      "latitude" => venue['location']['lat'],
      "longitude" => venue['location']['lng']
    }
  }
  puts venues_class.post(params).body
end
params = {}
params[:where] = {
  "location" => {
    "$nearSphere" => {
      "__type" => "GeoPoint",
      "longitude" => 139.745433,
      "latitude" => 35.691152
    },
    "$maxDistanceInKilometers" => 10
  }
}
#  
puts venues_class.get params
#puts venues_class.get queries
