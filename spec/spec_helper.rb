$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
%w(rubygems rspec yaml).each do |f| 
  require f
end
require "ncmb"
