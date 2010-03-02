require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Lock do
  context "when converted to a string" do
    it "should be shortened if its duration falls within a day" do
      from = Chronic.parse( "1979-05-27 05:00" )
      lock = Lock.new( from, from + 3600 )
      lock.to_s.should == "1979/05/27 (Sun) 05:00 - 06:00"
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
