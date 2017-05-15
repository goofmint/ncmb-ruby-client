# frozen_string_literal: true

require 'spec_helper'
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    NCMB.initialize(
      application_key: yaml['application_key'],
      client_key: yaml['client_key']
    )
  end
  
  it 'Post #1' do
    text = 'Test task'
    queries = {todo: text}
    todo_class = NCMB::DataStore.new 'POST_TODO'
    todo = todo_class.new(queries).save
    todo.todo.should == text
  end
  
  it 'Post with location #1' do
    
  end
end
