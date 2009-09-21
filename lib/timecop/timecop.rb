require 'singleton'
require File.join(File.dirname(__FILE__), 'time_extensions')
require File.join(File.dirname(__FILE__), 'stack_item')

# Timecop
# * Wrapper class for manipulating the extensions to the Time, Date, and DateTime objects
# * Allows us to "freeze" time in our Ruby applications.
# * Optionally allows time travel to simulate a running clock, such time is not technically frozen.
# 
# This is very useful when your app's functionality is dependent on time (e.g. 
# anything that might expire).  This will allow us to alter the return value of
# Date.today, Time.now, and DateTime.now, such that our application code _never_ has to change.
class Timecop
  include Singleton
  
  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  # This is particularly useful for writing test methods where the passage of time is critical to the business
  # logic being tested.  For example:
  #
  #   joe = User.find(1)
  #   joe.purchase_home()
  #   assert !joe.mortgage_due?
  #   Timecop.freeze(2008, 10, 5) do
  #     assert joe.mortgage_due?
  #   end
  #
  # freeze and travel will respond to several different arguments:
  # 1. Timecop.freeze(time_inst)
  # 2. Timecop.freeze(datetime_inst)
  # 3. Timecop.freeze(date_inst)
  # 4. Timecop.freeze(offset_in_seconds)
  # 5. Timecop.freeze(year, month, day, hour=0, minute=0, second=0)
  #
  # When a block is also passed, Time.now, DateTime.now and Date.today are all reset to their
  # previous values after the block has finished executing.  This allows us to nest multiple 
  # calls to Timecop.travel and have each block maintain it's concept of "now."
  #
  # * Note: Timecop.freeze will actually freeze time.  This can cause unanticipated problems if
  #   benchmark or other timing calls are executed, which implicitly expect Time to actually move
  #   forward.
  #
  # * Rails Users: Be especially careful when setting this in your development environment in a 
  #   rails project.  Generators will load your environment, including the migration generator, 
  #   which will lead to files being generated with the timestamp set by the Timecop.freeze call 
  #   in your dev environment
  #
  # Returns the frozen time.
  def self.freeze(*args, &block)
    instance().send(:travel, :freeze, *args, &block)
    Time.now
  end
  
  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  # See Timecop#freeze for a sample of how to use (same exact usage syntax)
  #
  # * Note: Timecop.travel will not freeze time (as opposed to Timecop.freeze).  This is a particularly
  #   good candidate for use in environment files in rails projects.
  #
  # Returns the 'new' current Time.
  def self.travel(*args, &block)
    instance().send(:travel, :move, *args, &block)
    Time.now
  end
  
  # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists). If freeze_all or rebase_all
  # was never called in the first place, this method will have no effect.
  #
  # Returns Time.now, which is now the real current time.
  def self.return
    instance().send(:unmock!)
    Time.now
  end

  protected
  
    def initialize #:nodoc:
      @_stack = []
    end
    
    def travel(mock_type, *args, &block) #:nodoc:
      # parse the arguments, build our base time units
      year, month, day, hour, minute, second = parse_travel_args(*args)

      # perform our action
      if mock_type == :freeze
        freeze_all(year, month, day, hour, minute, second)
      else
        move_all(year, month, day, hour, minute, second)
      end
      # store this time traveling on our stack...
      @_stack << StackItem.new(mock_type, year, month, day, hour, minute, second)
    
      if block_given?
        begin
          yield
        ensure
          # pull it off the stack...
          stack_item = @_stack.pop
          if @_stack.size == 0
            # completely unmock if there's nothing to revert back to 
            unmock!
          else
            # or reinstantiate the new the top of the stack (could be a :freeze or a :move)
            new_top = @_stack.last
            if new_top.mock_type == :freeze
              freeze_all(new_top.year, new_top.month, new_top.day, new_top.hour, new_top.minute, new_top.second)
            else
              move_all(new_top.year, new_top.month, new_top.day, new_top.hour, new_top.minute, new_top.second)
            end
          end
        end
      end
    end
  
    def unmock! #:nodoc:
      @_stack = []
      Time.unmock!
    end
  
  private
  
    # Re-bases Time.now, Date.today and DateTime.now (if it exists) to use the time passed in.
    # When using this method directly, it is up to the developer to call unset_all to return us
    # to sanity.
    #
    # * If being consumed in a rails app, Time.zone.local will be used to instantiate the time.
    #   Otherwise, Time.local will be used.
    def freeze_all(year, month, day, hour=0, minute=0, second=0)
      if Time.respond_to?(:zone) && !Time.zone.nil?
        # ActiveSupport loaded
        time = Time.zone.local(year, month, day, hour, minute, second)
      else 
        # ActiveSupport not loaded
        time = Time.local(year, month, day, hour, minute, second)
      end
    
      Time.freeze_time(time)
    end

    # Re-bases Time.now, Date.today and DateTime.now to use the time passed in and to continue moving time
    # forward.  When using this method directly, it is up to the developer to call return to return us to
    # sanity.
    #
    # * If being consumed in a rails app, Time.zone.local will be used to instantiate the time.
    #   Otherwise, Time.local will be used.
    def move_all(year, month, day, hour=0, minute=0, second=0)
      if Time.respond_to?(:zone) && !Time.zone.nil?
        # ActiveSupport loaded
        time = Time.zone.local(year, month, day, hour, minute, second)
      else 
        # ActiveSupport not loaded
        time = Time.local(year, month, day, hour, minute, second)
      end
    
      Time.move_time(time)
    end
    
    def parse_travel_args(*args)
      arg = args.shift
      if arg.is_a?(Time) || (Object.const_defined?(:DateTime) && arg.is_a?(DateTime))
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec
      elsif Object.const_defined?(:Date) && arg.is_a?(Date)
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, 0, 0, 0
        #puts "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
      elsif args.empty? && arg.kind_of?(Integer)
        t = Time.now + arg
        year, month, day, hour, minute, second = t.year, t.month, t.day, t.hour, t.min, t.sec
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
