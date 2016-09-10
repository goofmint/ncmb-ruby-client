$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'ncmb'
require 'yaml'
yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
NCMB.initialize application_key: yaml['application_key'],  client_key: yaml['client_key']

@users = []

@ids = [
  {id: 'testUser1', password: 'testPassword1'},
  {id: 'testUser2', password: 'testPassword2'}
]
@ids.each do |hash|
  @user = NCMB::User.login(hash[:id], hash[:password])
  if @user
  else
    @user = NCMB::User.new
    @user.set('userName', hash[:id])
    @user.set('password', hash[:password])
    if @user.signUp
    else
      puts "User create failed. #{@user.error.message}"
      exit
    end
  end
  @users << @user
end

@testData = NCMB::DataStore.new 'testData'
@testData.delete_all

@item = @testData.new
@item.Message = 'World'
@item.acl.public('read', true)
@item.acl.public('write', false)
@item.acl.user(@users[0], 'read', true)
@item.acl.user(@users[0], 'write', true)
@role = NCMB::Role.find_or_create("manager2")

@item.acl.role(@role, 'read', true)
@item.acl.role(@role, 'write', true)
@item.save

@data = @testData.where('objectId', @item.objectId).limit(1).get

@user = NCMB::User.login(@ids[0][:id], @ids[0][:password])
@testData.delete_all
