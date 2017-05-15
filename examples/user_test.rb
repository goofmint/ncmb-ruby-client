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

if @user = NCMB::User.login('testUser2', 'testPassword2')
  puts NCMB.CurrentUser.userName
  NCMB.CurrentUser.delete
  begin
    @user.delete
  rescue => e
    puts e.message
  end
end

@user = NCMB::User.new
@user.set('userName', 'testUser2')
@user.set('password', 'testPassword2')
if @user.signUp
  puts 'User create successful.'
  @user.set('Hello', 'World')
  @user.update
else
  puts "User create failed. #{@user.error.message}"
end
