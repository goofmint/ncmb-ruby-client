# frozen_string_literal: true

require 'spec_helper'
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    NCMB.initialize(
      application_key: yaml['application_key'],
      client_key: yaml['client_key']
    )
    @todoClass = todoClass = NCMB::DataStore.new 'GET_TODO'
    @todoClass.delete_all
    10.times do |i|
      @todoClass.new(text: "Task ##{i + 1}").save
    end
  end
  
  it 'Get #1' do
    @items = @todoClass.order('-createDate').skip(0).all
    @items.length.should == 10
  end
  
end
