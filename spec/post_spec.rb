require "spec_helper"
describe NCMB do
  before do
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'setting.yml'))
    @ncmb = NCMB.init(application_key: yaml['application_key'], 
                      client_key: yaml['client_key']
                      )
  end
  
  it "Post #1" do
    queries = {todo: "Test task"}
    todo_class = @ncmb.data_store 'TODO'
    response = todo_class.post queries
    # {"createDate":"2014-05-20T01:53:25.280Z","objectId":"rEDC6P4EgfiBf0AZ"}
    puts response.body
  end
  
  it "Post with location #1" do
    
  end
end
