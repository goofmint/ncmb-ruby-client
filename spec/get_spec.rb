require "spec_helper"
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    @ncmb = NCMB.init(application_key: yaml['application_key'], 
                      client_key: yaml['client_key']
                      )
  end
  
  it "Get #1" do
    queries = {:count => "1", :limit => "20", :order => "-createDate", :skip => "0"}
    todo_class = @ncmb.data_store 'TODO'
    puts todo_class.get queries
  end
end
