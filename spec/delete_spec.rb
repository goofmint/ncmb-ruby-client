require "spec_helper"
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    @ncmb = NCMB::Client.new(application_key: yaml['application_key'], 
                      client_key: yaml['client_key']
                      )
    @object_id = @ncmb.post('/2013-09-01/classes/TODO', todo: "Test task")[:objectId]
  end
  
  it "Delete #1" do
    res = @ncmb.delete("/2013-09-01/classes/TODO/#{@object_id}")
    res.should == {}
  end

  it "Delete #2" do
    res = @ncmb.delete("/2013-09-01/classes/TODO/doesnotexist")
    res[:code].should == 'E404001'
  end
end
