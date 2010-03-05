#
# A lock class
#
class Lock
  TIME_FORMAT_LONG = "%Y/%m/%d (%a) %H:%M"
  TIME_FORMAT_MEDIUM = "%m/%d (%a) %H:%M"
  TIME_FORMAT_SHORT = "%H:%M"


  attr_reader :from
  attr_reader :to


  def initialize from, to, user
    @from = from
    @to = to
    @user = user
  end


  def duration
    @to - @from
  end


  def obsolete?
    @to < Time.now
  end


  def overwrap_with other
    not ( @to < other.from || other.to < @from )
  end


  def == other
    @from == other.from && @to == other.to
  end


  def <=> other
    @from <=> other.from
  end


  def to_s
    "[#{ @user }] #{ from_string } - #{ to_string }"
  end


  ##############################################################################
  private
  ##############################################################################


  def from_string
    @from.strftime TIME_FORMAT_LONG
  end


  def to_string
    if fit_within_a_day?
      @to.strftime TIME_FORMAT_SHORT
    elsif fit_within_a_year?
      @to.strftime TIME_FORMAT_MEDIUM
    else
      @to.strftime TIME_FORMAT_LONG
    end
  end


  def fit_within_a_day?
    compare_from_to_in "%Y/%m/%d"
  end


  def fit_within_a_year?
    compare_from_to_in "%Y"
  end


  def compare_from_to_in format
    @from.strftime( format ) == @to.strftime( format )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
