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

  class << self
    attr_accessor :active_support

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
    # Returns the value of the block or nil.
    def freeze(*args, &block)
      val = instance.send(:travel, :freeze, *args, &block)

      block_given? ? val : nil
    end

    # Allows you to run a block of code and "fake" a time throughout the execution of that block.
    # See Timecop#freeze for a sample of how to use (same exact usage syntax)
    #
    # * Note: Timecop.travel will not freeze time (as opposed to Timecop.freeze).  This is a particularly
    #   good candidate for use in environment files in rails projects.
    #
    # Returns the value of the block or nil.
    def travel(*args, &block)
      val = instance.send(:travel, :travel, *args, &block)

      block_given? ? val : nil
    end

    # Allows you to run a block of code and "scale" a time throughout the execution of that block.
    # The first argument is a scaling factor, for example:
    #   Timecop.scale(2) do
    #     ... time will 'go' twice as fast here
    #   end
    # See Timecop#freeze for exact usage of the other arguments
    #
    # Returns the value of the block or nil.
    def scale(*args, &block)
      val = instance.send(:travel, :scale, *args, &block)

      block_given? ? val : nil
    end

    def baseline
      instance.send(:baseline)
    end

    def baseline=(baseline)
      instance.send(:baseline=, baseline)
    end

    # Reverts back to system's Time.now, Date.today and DateTime.now (if it exists).
    def return
      instance.send(:unmock!)
      nil
    end

    def return_to_baseline
      instance.send(:return_to_baseline)
      Time.now
    end

    def top_stack_item #:nodoc:
      instance.instance_variable_get(:@_stack).last
    end

    # execute the block in realtime
    def in_realtime(&block)
      instance.send(:in_realtime, &block)
    end
  end


  private

  def baseline=(baseline)
    @baseline = baseline
    @_stack << TimeStackItem.new(:travel, baseline)
  end

  def initialize #:nodoc:
    @_stack = []
  end

  def travel(mock_type, *args, &block) #:nodoc:
    stack_item = TimeStackItem.new(mock_type, *args)

    @_stack << stack_item

    if block_given?
      begin
        yield stack_item.time
      ensure
        @_stack.pop
      end
    end
  end

  def in_realtime(&block)
    current_stack = @_stack
    current_baseline = @baseline
    unmock!
    yield
  ensure
    @_stack = current_stack
    @baseline = current_baseline
  end



  def unmock! #:nodoc:
    @baseline = nil
    @_stack = []
  end

  def return_to_baseline
    if @baseline
      @_stack = [@_stack.shift]
    else
      unmock!
    end
  end
end
