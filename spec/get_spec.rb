# -*- coding: utf-8 -*-
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
    # {"count":5,"results":[{"objectId":"VwswoCe7PEuSbGEU","createDate":"2014-05-07T12:03:37.428Z","updateDate":"2014-05-07T12:03:37.428Z","acl":{"*":{"read":true,"write":true}},"todo":"タスクの追加"},{"objectId":"pj9scMgCGQ3wyd5m","createDate":"2014-05-07T08:03:56.268Z","updateDate":"2014-05-07T08:03:56.268Z","acl":{"*":{"read":true,"write":true}},"todo":"タスクを追加"},{"objectId":"lq3CIoaSAcM5Du6I","createDate":"2014-05-07T08:03:44.181Z","updateDate":"2014-05-07T08:03:44.181Z","acl":{"*":{"read":true,"write":true}},"todo":"テストのタスク"},{"objectId":"jln8aWojgUDUnCYo","createDate":"2014-05-07T08:02:23.104Z","updateDate":"2014-05-07T08:02:23.104Z","acl":{"*":{"read":true,"write":true}},"todo":"レビューします"},{"objectId":"zhRGEjECBdaUBLLn","createDate":"2014-05-07T08:02:10.573Z","updateDate":"2014-05-07T08:02:10.573Z","acl":{"*":{"read":true,"write":true}},"todo":"記事を書きます"}]}
    # puts todo_class.get queries
  end
end
