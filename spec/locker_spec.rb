require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Locker do
  before :each do
    FileUtils.rm_f "/tmp/ll.dat"
    @locker = Locker.new( "/tmp/ll.dat", :no_resolver => true )
    @time_now = Time.now
    @old_lock = Lock.new( Chronic.parse( "2019-05-27 05:00" ), Chronic.parse( "2019-05-27 08:00" ), "yasuhito" )
    @new_lock = Lock.new( Chronic.parse( "2020-05-27 05:00" ), Chronic.parse( "2020-05-27 08:00" ), "yasuhito" )
  end


  it "should raise if failed to resolve nodes' IP address" do
    @locker = Locker.new( "/tmp/ll.dat" )
    lambda do
      @locker.lock "NO_SUCH_NODE", @old_lock
    end.should raise_error( LL::LockError, "Failed to lock NO_SUCH_NODE: invalid node name" )
  end


  it "should keep a sorted lock list" do
    @locker.locks( "tick001" ).should be_empty
    @locker.lock "tick001", @new_lock
    @locker.locks( "tick001" ).should == [ @new_lock ]
    @locker.lock "tick001", @old_lock
    @locker.locks( "tick001" ).should == [ @old_lock, @new_lock ]
  end


  it "should unlock a node" do
    @locker.lock "tick001", @new_lock
    @locker.lock "tick001", @old_lock

    @locker.unlock "tick001", @new_lock
    @locker.locks( "tick001" ).should == [ @old_lock ]
    @locker.unlock "tick001", @old_lock
    @locker.locks( "tick001" ).should be_empty
  end


  it "should delete similar locks from its list" do
    @locker.lock "tick001", @new_lock
    @locker.lock "tick002", @new_lock
    @locker.lock "tick002", @old_lock
    @locker.lock "tick003", @old_lock

    @locker.unlock_all( @new_lock )
    @locker.locks( "tick001" ).should be_empty
    @locker.locks( "tick002" ).should == [ @old_lock ]
    @locker.locks( "tick003" ).should == [ @old_lock ]
  end


  it "should find nodes locked with a specified lock" do
    @locker.lock "tick001", @new_lock
    @locker.lock "tick002", @new_lock
    @locker.lock "tick002", @old_lock
    @locker.lock "tick003", @old_lock

    @locker.find_nodes_locked_with( @new_lock ).should == [ "tick001", "tick002" ]
    @locker.find_nodes_locked_with( @old_lock ).should == [ "tick002", "tick003" ]
  end


  context "when attempt to acquire a lock for a node" do
    it "should lock a node today" do
      @locker.lock [ "tick001" ], Lock.new( @time_now, Chronic.parse( "this midnight" ), "yasuhito" )
      @locker.locks( "tick001" ).size.should == 1
      @locker.locks( "tick001" ).first.duration.should < 86400 # 1 day
    end


    it "should lock a node 8 hours" do
      @locker.lock [ "tick001" ], Lock.new( @time_now, @time_now + ChronicDuration.parse( "8 hours" ), "yasuhito" )
      @locker.locks( "tick001" ).size.should == 1
      @locker.locks( "tick001" ).first.duration.should == 28800 # 8 hours
    end


    it "should lock a node 3 days from tomorrow" do
      @locker.lock [ "tick001" ], Lock.new( Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow" ) + ChronicDuration.parse( "3 days" ), "yasuhito" )
      @locker.locks( "tick001" ).size.should == 1
      @locker.locks( "tick001" ).first.duration.should == 259200 # 3 days
    end
  end


  context "when someone already locked tick001 today" do
    before :each do
      @locker.lock [ "tick001" ], Lock.new( @time_now, Chronic.parse( "this midnight" ), "yasuhito" )
    end


    it "should fail to lock tick001" do
      lambda do
        @locker.lock [ "tick001" ], Lock.new( @time_now, Chronic.parse( "this midnight" ), "yasuhito" )
      end.should raise_error( LL::LockError, "Failed to lock tick001" )
    end


    it "should succeed to lock tick001 tomorrow" do
      lambda do
        @locker.lock [ "tick001" ], Lock.new( Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow" ) + ChronicDuration.parse( "24 hours" ), "yasuhito" )
      end.should_not raise_error
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
