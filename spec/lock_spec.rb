require File.join( File.dirname( __FILE__ ), "spec_helper" )


Spec::Matchers.define :overwrap_with do | duration |
  match do | lock |
    lock.overwrap_with new_lock( duration )
  end
end


Spec::Matchers.define :be_shortened_into do | string |
  match do | lock |
    lock.to_s == string
  end
end


Spec::Matchers.define :be_older_than do | other_lock |
  match do | lock |
    ( lock <=> other_lock ) == -1
  end
end


Spec::Matchers.define :be_newer_than do | other_lock |
  match do | lock |
    ( lock <=> other_lock ) == 1
  end
end


describe Lock, "1979-05-27 04:00 - 1979-05-27 05:00" do
  subject { new_lock( :from => "1979-05-27 04:00", :to => "1979-05-27 05:00" ) }


  context "when compared with an another lock" do
    it { should be_older_than( new_lock( :from => "1979-05-27 05:00", :to => "1979-05-27 06:00" ) ) }
    it { should == new_lock( :from => "1979-05-27 04:00", :to => "1979-05-27 05:00" ) }
    it { should_not == new_lock( :from => "1980-05-27 04:00", :to => "1980-05-27 05:00" ) }
    it { should be_newer_than( new_lock( :from => "1979-05-27 03:00", :to => "1979-05-27 04:00" ) ) }
  end


  context "when detecting overwrap" do
    it { should overwrap_with( :from => "1979-05-27 03:00", :to => "1979-05-27 06:00" ) }
    it { should overwrap_with( :from => "1979-05-27 03:00", :to => "1979-05-27 04:30" ) }
    it { should overwrap_with( :from => "1979-05-27 04:30", :to => "1979-05-27 06:00" ) }
    it { should overwrap_with( :from => "1979-05-27 04:15", :to => "1979-05-27 04:45" ) }
    it { should_not overwrap_with( :from => "1979-05-27 06:00", :to => "1979-05-27 07:00" ) }
  end


  context "when calculating its duration" do
    its( :duration ) { should == ChronicDuration.parse( "1 hour" ) }
  end


  context "when testing its lifetime" do
    it { should be_obsolete }
  end
end


describe Lock, "with 1 hour of duration from now" do
  context "when testing its lifetime" do
    now = Time.now
    subject { Lock.new( now, now + ChronicDuration.parse( "1 hour" ), "yutaro" ) }
    it { should_not be_obsolete }
  end
end


describe Lock, "when its duration falls within a day" do
  subject { new_lock( :from => "1979-05-27 05:00", :to => "1979-05-27 06:00", :user => "yutaro" ) }
  it { should be_shortened_into( "[yutaro] 1979/05/27 (Sun) 05:00 - 06:00" ) }
end


describe Lock, "when its duration crosses 00:00" do
  subject { new_lock( :from => "1979-05-27 23:00", :to => "1979-05-28 01:00", :user => "yutaro" ) }
  it { should be_shortened_into( "[yutaro] 1979/05/27 (Sun) 23:00 - 05/28 (Mon) 01:00" ) }
end


describe Lock, "when its duration crosses the last day of a month" do
  subject { new_lock( :from => "1979-01-31 23:00", :to => "1979-02-1 01:00", :user => "yutaro" ) }
  it { should be_shortened_into( "[yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00" ) }
end


describe Lock, "when its duration crosses a new year's day" do
  subject { new_lock( :from => "1978-12-31 23:00", :to => "1979-01-01 01:00", :user => "yutaro" ) }
  it { should be_shortened_into( "[yutaro] 1978/12/31 (Sun) 23:00 - 1979/01/01 (Mon) 01:00" ) }
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
