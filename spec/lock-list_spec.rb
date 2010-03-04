require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Locker do
  before :each do
    FileUtils.rm_f "/tmp/ll.dat"
    @locker = Locker.new( "/tmp/ll.dat" )
    @old_lock = Lock.new( Chronic.parse( "2019-05-27 05:00" ), Chronic.parse( "2019-05-27 08:00" ) )
    @new_lock = Lock.new( Chronic.parse( "2020-05-27 05:00" ), Chronic.parse( "2020-05-27 08:00" ) )
  end


  it "should keep a sorted lock list" do
    @locker.locks( "tick001" ).should be_empty
    @locker.lock "tick001", @new_lock.from, @new_lock.to
    @locker.locks( "tick001" ).should == [ @new_lock ]
    @locker.lock "tick001", @old_lock.from, @old_lock.to
    @locker.locks( "tick001" ).should == [ @old_lock, @new_lock ]
  end


  it "should unlock a node" do
    @locker.lock "tick001", @new_lock.from, @new_lock.to
    @locker.lock "tick001", @old_lock.from, @old_lock.to

    @locker.unlock "tick001", @new_lock
    @locker.locks( "tick001" ).should == [ @old_lock ]
    @locker.unlock "tick001", @old_lock
    @locker.locks( "tick001" ).should be_empty
  end


  it "should delete similar locks from its list" do
    @locker.lock "tick001", @new_lock.from, @new_lock.to
    @locker.lock "tick002", @new_lock.from, @new_lock.to
    @locker.lock "tick002", @old_lock.from, @old_lock.to
    @locker.lock "tick003", @old_lock.from, @old_lock.to

    @locker.unlock_all( @new_lock )
    @locker.locks( "tick001" ).should be_empty
    @locker.locks( "tick002" ).should == [ @old_lock ]
    @locker.locks( "tick003" ).should == [ @old_lock ]
  end


  it "should find nodes locked with a specified lock" do
    @locker.lock "tick001", @new_lock.from, @new_lock.to
    @locker.lock "tick002", @new_lock.from, @new_lock.to
    @locker.lock "tick002", @old_lock.from, @old_lock.to
    @locker.lock "tick003", @old_lock.from, @old_lock.to

    @locker.find_nodes_locked_with( @new_lock ).should == [ "tick001", "tick002" ]
    @locker.find_nodes_locked_with( @old_lock ).should == [ "tick002", "tick003" ]
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
