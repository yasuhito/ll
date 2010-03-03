require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe LockList do
  before :each do
    FileUtils.rm_f "/tmp/ll.dat"
    @locks = LockList.new( "/tmp/ll.dat" )
    @old_lock = Lock.new( Chronic.parse( "yesterday" ), Chronic.parse( "today" ) )
    @new_lock = Lock.new( Chronic.parse( "today" ), Chronic.parse( "tomorrow" ) )
  end


  it "should keep a sorted lock list" do
    @locks.status( "tick001" ).should be_empty
    @locks.add "tick001", @new_lock
    @locks.status( "tick001" ).should == [ @new_lock ]
    @locks.add "tick001", @old_lock
    @locks.status( "tick001" ).should == [ @old_lock, @new_lock ]
  end


  it "should delete a lock from its list" do
    @locks.add "tick001", @new_lock
    @locks.add "tick001", @old_lock

    @locks.delete "tick001", @new_lock
    @locks.status( "tick001" ).should == [ @old_lock ]
    @locks.delete "tick001", @old_lock
    @locks.status( "tick001" ).should be_empty
  end


  it "should find similar locks from its list" do
    @locks.add "tick001", @new_lock
    @locks.add "tick002", @new_lock
    @locks.add "tick002", @old_lock
    @locks.add "tick003", @old_lock

    @locks.find_similar_locks( @new_lock ).should == [ "tick001", "tick002" ]
    @locks.find_similar_locks( @old_lock ).should == [ "tick002", "tick003" ]
  end


  it "should delete similar locks from its list" do
    @locks.add "tick001", @new_lock
    @locks.add "tick002", @new_lock
    @locks.add "tick002", @old_lock
    @locks.add "tick003", @old_lock

    @locks.delete_similar_locks( @new_lock )
    @locks.status( "tick001" ).should be_empty
    @locks.status( "tick002" ).should == [ @old_lock ]
    @locks.status( "tick003" ).should == [ @old_lock ]
  end


  it "should determine if users can acquire a new lock" do
    @locks.add "tick001", @new_lock

    @locks.lockable?( "tick001", @new_lock ).should be_false
    @locks.lockable?( "tick002", @new_lock ).should be_true
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
