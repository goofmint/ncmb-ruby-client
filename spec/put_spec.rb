require 'spec_helper'
describe NCMB do
  before do
    yaml = YAML.load_file(
      File.join(File.dirname(__FILE__), '..', 'setting.yml')
    )
    @ncmb = NCMB::Client.new(
      application_key: yaml['application_key'],
      client_key: yaml['client_key']
    )
    @object_id = @ncmb.post(
      '/2013-09-01/classes/TODO',
      todo: 'Test task'
    )[:objectId]
  end

  it 'Put #1' do
    res = @ncmb.put(
      "/2013-09-01/classes/TODO/#{@object_id}",
      todo: 'Test task updated'
    )
    res[:updateDate].should_not be_nil
  end
end
