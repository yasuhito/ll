# -*- coding: utf-8 -*-
Given /^空のロックデータファイル$/ do
  @data = "/tmp/ll.dat"
  FileUtils.rm_f @data
end


When /^ll lock "([^\"]*)" でロックをかけた$/ do | argv |
  @messenger = StringIO.new
  @app = AppLock.new( :messenger => @messenger, :no_resolver => true, :user => "yutaro" )
  @app.parse argv.split( " " ) + [ "--data", @data ]
  @app.start
end


Then /^ノード "([^\"]*)" が (\d+) 時間ほどロックされる$/ do | node, hours |
  @app.locks_for( node ).first.duration.to_i.should == hours.to_i * 3600
end


Then /^ノード "([^\"]*)" が今日一日の間ロックされる$/ do | node |
  expected = Chronic.parse( "this midnight" ) - Time.now
  @app.locks_for( node ).first.duration.to_i.should == expected.to_i
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
