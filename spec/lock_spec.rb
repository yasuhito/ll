require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Lock do
  before :each do
    @one_hour = ChronicDuration.parse( "1 hour" )
    @user = "yutaro"
  end


  context "when it is expired" do
    past = Chronic.parse( "1979-05-27 05:00" )
    subject { Lock.new( past - @one_hour, past, @user ) }
    it { should be_obsolete }
  end


  context "when it is alive" do
    now = Time.now
    subject { Lock.new( now, now + @one_hour, @user ) }
    it { should_not be_obsolete }
  end
end


describe Lock, "when converted to a string" do
  before :each do
    @user = "yutaro"
  end


  it "should be shortened if its duration falls within a day" do
    lock = Lock.new( Chronic.parse( "1979-05-27 05:00" ),
                     Chronic.parse( "1979-05-27 06:00" ), @user )
    lock.to_s.should == "[yutaro] 1979/05/27 (Sun) 05:00 - 06:00"
  end


  it "should be shortened if its duration falls within a year" do
    lock = Lock.new( Chronic.parse( "1979-01-31 23:00" ),
                     Chronic.parse( "1979-02-1 01:00" ), @user )
    lock.to_s.should == "[yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00"
  end


  it "should not be shortened if its duration crosses a new year's day" do
    lock = Lock.new( Chronic.parse( "1978-12-31 23:00" ),
                     Chronic.parse( "1979-01-01 01:00" ), @user )
    lock.to_s.should == "[yutaro] 1978/12/31 (Sun) 23:00 - 1979/01/01 (Mon) 01:00"
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
