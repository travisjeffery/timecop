
# Simply a data class for carrying around "time movement" objects.  Makes it easy to keep track of the time
# movements on a simple stack.
class StackItem
  
  attr_reader :mock_type, :year, :month, :day, :hour, :minute, :second
  def initialize(mock_type, year, month, day, hour, minute, second)
    @mock_type, @year, @month, @day, @hour, @minute, @second = mock_type, year, month, day, hour, minute, second
  end
end

