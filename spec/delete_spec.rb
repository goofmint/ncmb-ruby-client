# frozen_string_literal: true

require 'spec_helper'
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    NCMB.initialize(
      application_key: yaml['application_key'],
      client_key: yaml['client_key']
    )
    @Todo = NCMB::DataStore.new('TODO')
    @todo = @Todo.new(text: 'Test task')
    @object_id = @todo.save().objectId
  end
  
  it 'Delete #1' do
    @todo.delete.should == true
  end

  it 'Delete again' do
    @todo.delete.should == true
    @todo.delete.should == false
    @todo.error[:code].should == 'E404001'
  end
end
