$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
require 'open-uri'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

f = NCMB::NFile.new('http://mb.cloud.nifty.com/assets/images/logo.png')
f.acl.public('read', true)
f.acl.public('write', true)
f.fileName = "test.png"
f.save()
puts "Uploaded"
f.file = 'http://k.yimg.jp/images/top/sp2/cmn/logo-ns_d_131205.png'
f.update()
puts "Updated"
f.delete()
puts "Deleted"

f = NCMB::NFile.new('http://mb.cloud.nifty.com/assets/images/logo.png')
f.acl.public('read', true)
f.acl.public('write', true)
f.fileName = "test.png"
f.save()
file = NCMB::NFile.new("test.png")
fp = open("test.png", "w")
fp.write(file.get)
fp.close
