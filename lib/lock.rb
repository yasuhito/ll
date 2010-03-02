#
# A lock class
#
class Lock
  DEFAULT_TIME_FORMAT = "%Y/%m/%d (%a) %H:%M"
  SHORT_TIME_FORMAT = "%H:%M"


  attr_reader :from
  attr_reader :to


  def initialize from, to
    @from = from
    @to = to
  end


  def duration
    @to - @from
  end


  def overwrap_with other
    not ( @to < other.from || other.to < @from )
  end


  def <=> other
    @from <=> other.from
  end


  def to_s
    "#{ from_string } - #{ to_string }"
  end


  ##############################################################################
  private
  ##############################################################################


  def from_string
    @from.strftime DEFAULT_TIME_FORMAT
  end


  def to_string
    if same_day?
      @to.strftime SHORT_TIME_FORMAT
    else
      @to.strftime DEFAULT_TIME_FORMAT
    end
  end


  def same_day?
    format = "%Y/%m/%d"
    @from.strftime( format ) == @to.strftime( format )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
