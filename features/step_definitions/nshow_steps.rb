# -*- coding: utf-8 -*-
When /^ロックを表示した$/ do
  @messenger = StringIO.new
  @app = AppShow.new( @messenger )
  @app.parse [ "--data", @nlock_dat ]
  @app.start
end


Then /^次の出力を得る:$/ do | string |
  @messenger.string.chomp.should == string
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
