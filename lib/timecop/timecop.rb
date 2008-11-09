require File.join(File.dirname(__FILE__), 'time_extensions')

# 1. Wrapper class for manipulating the extensions to the Time, Date, and DateTime objects
# 2. Allows us to "freeze" time in our Ruby applications.
# 3. This is very useful when your app's functionality is dependent on time (e.g. 
# anything that might expire).  This will allow us to alter the return value of
# Date.today, Time.now, and DateTime.now, such that our application code _never_ has to change.
class Timecop
  
  # Re-bases Time.now, Date.today and DateTime.now (if it exists) to use the time passed in.
  # When using this method directly, it is up to the developer to call unset_all to return us
  # to sanity.
  #
  # * If being consumed in a rails app, Time.zone.local will be used to instantiate the time.
  #   Otherwise, Time.local will be used.
  def self.set_all(year, month, day, hour=0, minute=0, second=0)
    if Time.respond_to?(:zone) && !Time.zone.nil?
      # ActiveSupport loaded
      time = Time.zone.local(year, month, day, hour, minute, second)
    else 
      # ActiveSupport not loaded
      time = Time.local(year, month, day, hour, minute, second)
    end
    
    Time.mock_time = time
    Date.mock_date = Date.new(time.year, time.month, time.day) if Object.const_defined?(:Date)
    DateTime.mock_time = DateTime.new(time.year, time.month, time.day, time.hour, time.min, time.sec) if Object.const_defined?(:DateTime)
  end
  
  # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists). If set_all
  # was never called in the first place, this method will have no effect.
  def self.unset_all
    Date.mock_date = nil
    DateTime.mock_time = nil if Object.const_defined?(:Date)
    Time.mock_time = nil if Object.const_defined?(:DateTime)
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
  #
  # travel will respond to several different arguments:
  # 1. Timecop.travel(time_inst)
  # 2. Timecop.travel(datetime_inst)
  # 3. Timecop.travel(date_inst)
  # 4. Timecop.travel(year, month, day, hour=0, minute=0, second=0)
  #
  # When a block is also passed, the Time.now, DateTime.now and Date.today are all reset to their
  # previous values.  This allows us to nest multiple calls to Timecop.travel and have each block
  # maintain it's concept of "now."
  #def self.travel(year, month, day, hour=0, minute=0, second=0, &block)
  def self.travel(*args, &block)
    year, month, day, hour, minute, second = parse_travel_args(*args)

    old_time = Time.mock_time
    old_date = Date.mock_date if Object.const_defined?(:Date)
    old_datetime = DateTime.mock_time if Object.const_defined?(:DateTime)

    set_all(year, month, day, hour, minute, second)
    
    if block_given?
      begin
        yield
      ensure
        Time.mock_time = old_time
        Date.mock_date = old_date if Object.const_defined?(:Date)
        DateTime.mock_time = old_datetime if Object.const_defined?(:DateTime)
      end
    end
  end
  
  private
    def self.parse_travel_args(*args)
      arg = args.shift
      if arg.is_a?(Time) || (Object.const_defined?(:DateTime) && arg.is_a?(DateTime))
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec
      elsif Object.const_defined?(:Date) && arg.is_a?(Date)
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, 0, 0, 0
        puts "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
      else # we'll just assume it's a list of y/m/h/d/m/s
        year   = arg        || 0
        month  = args.shift || 1
        day    = args.shift || 1
        hour   = args.shift || 0
        minute = args.shift || 0
        second = args.shift || 0
      end
      return year, month, day, hour, minute, second
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

