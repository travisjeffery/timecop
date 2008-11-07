require 'timecop/time_extensions'

class Timecop
  # Re-bases Time.now, Date.today and DateTime.now (if it exists) to use the time passed in.
  # When using this method directly, it is up to the developer to call unset_all to return us
  # to sanity.
  #
  # * If being consumed in a rails app, Time.zone.local will be used to instantiate the time.
  #   Otherwise, Time.local will be used.
  def self.set_all(year, month, day, hour=0, minute=0, second=0)
    time = Time.zone.local(year, month, day, hour, minute, second)
    Time.mock_time = time
    Date.mock_date = Date.new(time.year, time.month, time.day)
    DateTime.mock_time = DateTime.new(time.year, time.month, time.day, time.hour, time.min, time.sec)
  end
  
  # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists). If set_all
  # was never called in the first place, this method will have no effect.
  def self.unset_all
    Date.mock_date = nil
    DateTime.mock_time = nil
    Time.mock_time = nil
  end
  
  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  # This is particularly useful for writing test methods where the passage of time is critical to the business
  # logic being tested.  For example:
  #
  # <code>
  #   joe = User.find(1)
  #   joe.purchase_home()
  #   assert !joe.mortgage_due?
  #   Timecop.travel(2008, 10, 5) do
  #     assert joe.mortgage_due?
  #   end
  # </code>
  def self.travel(year, month, day, hour=0, minute=0, second=0, &block)
    old_date, old_time, old_datetime = Date.mock_date, Time.mock_time, DateTime.mock_time

    set_all(year, month, day, hour, minute, second)
    
    yield
    
    Date.mock_date = old_date
    Time.mock_time = old_time
    DateTime.mock_time = old_datetime
  end
end

#def with_dates(*dates, &block)
#  dates.flatten.each do |date|
#    begin
#      DateTime.forced_now = case date
#        when String: DateTime.parse(date)
#        when Time: DateTime.parse(date.to_s)
#        else
#          date
#      end
#      Date.forced_today = Date.new(DateTime.forced_now.year,
#DateTime.forced_now.month, DateTime.forced_now.day)
#      yield
#    rescue Exception => e
#      raise e
#    ensure
#      DateTime.forced_now = nil
#      Date.forced_today = nil
#    end
#  end
#end 

