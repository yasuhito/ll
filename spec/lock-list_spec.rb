require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe LockList do
  before :each do
    FileUtils.rm_f "/tmp/ll.dat"
    @locks = LockList.new( "/tmp/ll.dat" )
    @old_lock = Lock.new( Chronic.parse( "2019-05-27 05:00" ), Chronic.parse( "2019-05-27 08:00" ) )
    @new_lock = Lock.new( Chronic.parse( "2020-05-27 05:00" ), Chronic.parse( "2020-05-27 08:00" ) )
  end


  it "should keep a sorted lock list" do
    @locks.locks( "tick001" ).should be_empty
    @locks.lock "tick001", @new_lock.from, @new_lock.to
    @locks.locks( "tick001" ).should == [ @new_lock ]
    @locks.lock "tick001", @old_lock.from, @old_lock.to
    @locks.locks( "tick001" ).should == [ @old_lock, @new_lock ]
  end


  it "should unlock a node" do
    @locks.lock "tick001", @new_lock.from, @new_lock.to
    @locks.lock "tick001", @old_lock.from, @old_lock.to

    @locks.unlock "tick001", @new_lock
    @locks.locks( "tick001" ).should == [ @old_lock ]
    @locks.unlock "tick001", @old_lock
    @locks.locks( "tick001" ).should be_empty
  end


  it "should delete similar locks from its list" do
    @locks.lock "tick001", @new_lock.from, @new_lock.to
    @locks.lock "tick002", @new_lock.from, @new_lock.to
    @locks.lock "tick002", @old_lock.from, @old_lock.to
    @locks.lock "tick003", @old_lock.from, @old_lock.to

    @locks.unlock_all( @new_lock )
    @locks.locks( "tick001" ).should be_empty
    @locks.locks( "tick002" ).should == [ @old_lock ]
    @locks.locks( "tick003" ).should == [ @old_lock ]
  end


  it "should find nodes locked with a specified lock" do
    @locks.lock "tick001", @new_lock.from, @new_lock.to
    @locks.lock "tick002", @new_lock.from, @new_lock.to
    @locks.lock "tick002", @old_lock.from, @old_lock.to
    @locks.lock "tick003", @old_lock.from, @old_lock.to

    @locks.find_nodes_locked_with( @new_lock ).should == [ "tick001", "tick002" ]
    @locks.find_nodes_locked_with( @old_lock ).should == [ "tick002", "tick003" ]
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
