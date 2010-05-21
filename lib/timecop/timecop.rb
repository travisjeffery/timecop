require 'singleton'
require 'timecop/time_extensions'
require 'timecop/time_stack_item'

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
    instance().send(:travel, :travel, *args, &block)
    Time.now
  end
  
  # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists).
  #
  # Returns Time.now, which is now the real current time.
  def self.return
    instance().send(:unmock!)
    Time.now
  end
  
  def self.top_stack_item #:nodoc:
    instance().instance_variable_get(:@_stack).last
  end

  protected
  
    def initialize #:nodoc:
      @_stack = []
    end
    
    def travel(mock_type, *args, &block) #:nodoc:
      stack_item = TimeStackItem.new(mock_type, *args)
      
      # store this time traveling on our stack...
      @_stack << stack_item
    
      if block_given?
        begin
          yield
        ensure
          # pull it off the stack...
          @_stack.pop
        end
      end
    end
  
    def unmock! #:nodoc:
      @_stack = []
    end
  
end
