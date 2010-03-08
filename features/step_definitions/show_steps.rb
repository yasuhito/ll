# -*- coding: utf-8 -*-
When /^ロックを表示した$/ do
  @messenger = StringIO.new
  @app = AppShow.new( :messenger => @messenger )
  @app.parse [ "--data", @data ]
  @app.start
end


Then /^何も表示されない$/ do
  @messenger.string.should be_empty
end


Then /^現在のロックは無し$/ do
  @messenger.string.should be_empty
end


Then /^次の出力を得る:$/ do | string |
  @messenger.string.chomp.should == string
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
