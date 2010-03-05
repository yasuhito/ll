require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Lock do
  context "when converted to a string" do
    it "should be shortened if its duration falls within a day" do
      from = Chronic.parse( "1979-05-27 05:00" )
      lock = Lock.new( from, from + 3600, "yasuhito" )
      lock.to_s.should == "[yasuhito] 1979/05/27 (Sun) 05:00 - 06:00"
    end


    it "should be shortened if its duration falls within a year" do
      from = Chronic.parse( "1979-01-31 23:00" )
      lock = Lock.new( from, from + 7200, "yasuhito" )
      lock.to_s.should == "[yasuhito] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00"
    end


    it "should not be shortened if its duration crosses a new year's day" do
      from = Chronic.parse( "1978-12-31 23:00" )
      lock = Lock.new( from, from + 7200, "yasuhito" )
      lock.to_s.should == "[yasuhito] 1978/12/31 (Sun) 23:00 - 1979/01/01 (Mon) 01:00"
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
