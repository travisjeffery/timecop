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
  
  # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists).
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

      stack_item = StackItem.new(mock_type, year, month, day, hour, minute, second)
      # perform our action
      freeze_or_move(stack_item)
      
      # store this time traveling on our stack...
      @_stack << stack_item
    
      if block_given?
        begin
          yield
        ensure
          # pull it off the stack...
          @_stack.pop
          if @_stack.size == 0
            # completely unmock if there's nothing to revert back to 
            unmock!
          else
            # or reinstantiate the new the top of the stack (could be a :freeze or a :move)
            new_top = @_stack.last
            freeze_or_move(new_top)
          end
        end
      end
    end
  
    def unmock! #:nodoc:
      @_stack = []
      Time.unmock!
    end
  
  private
  
    def freeze_or_move(stack_item) #:nodoc:
      if stack_item.mock_type == :freeze
        Time.freeze_time(time_for_stack_item(stack_item))
      else
        Time.move_time(time_for_stack_item(stack_item))
      end
    end
    
    def time_for_stack_item(stack_item) #:nodoc:
      if Time.respond_to?(:zone) && !Time.zone.nil?
        # ActiveSupport loaded
        time = Time.zone.local(stack_item.year, stack_item.month, stack_item.day, stack_item.hour, stack_item.minute, stack_item.second)
      else 
        # ActiveSupport not loaded
        time = Time.local(stack_item.year, stack_item.month, stack_item.day, stack_item.hour, stack_item.minute, stack_item.second)
      end      
    end
        
    def parse_travel_args(*args) #:nodoc:
      arg = args.shift
      if arg.is_a?(Time)
        arg = arg.getlocal
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec
      elsif Object.const_defined?(:DateTime) && arg.is_a?(DateTime)
        arg = arg.new_offset(DateTime.now_without_mock_time.offset)
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec
      elsif Object.const_defined?(:Date) && arg.is_a?(Date)
        year, month, day, hour, minute, second = arg.year, arg.month, arg.day, 0, 0, 0
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
