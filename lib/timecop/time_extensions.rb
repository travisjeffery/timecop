require 'time'
require 'date'

class Time #:nodoc:
  class << self
    def mock_time
      mocked_time_stack_item = Timecop.top_stack_item
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.time(self)
    end

    alias_method :now_without_mock_time, :now

    def now_with_mock_time
      mock_time || now_without_mock_time
    end

    alias_method :now, :now_with_mock_time

    alias_method :new_without_mock_time, :new

    def new_with_mock_time(*args)
      args.size <= 0 ? now : new_without_mock_time(*args)
    end

    alias_method :new, :new_with_mock_time
  end
end

class Date #:nodoc:
  class << self
    def mock_date
      mocked_time_stack_item = Timecop.top_stack_item
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.date(self)
    end

    alias_method :today_without_mock_date, :today

    def today_with_mock_date
      mock_date || today_without_mock_date
    end

    alias_method :today, :today_with_mock_date

    alias_method :strptime_without_mock_date, :strptime

    def strptime_with_mock_date(str = '-4712-01-01', fmt = '%F', start = Date::ITALY)
      unless start == Date::ITALY
        raise ArgumentError, "Timecop's #{self}::#{__method__} only " +
          "supports Date::ITALY for the start argument."
      end

      Time.strptime(str, fmt).to_date
    end

    alias_method :strptime, :strptime_with_mock_date
  end
end

class DateTime #:nodoc:
  class << self
    def mock_time
      mocked_time_stack_item = Timecop.top_stack_item
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.datetime(self)
    end

    def now_without_mock_time
      Time.now_without_mock_time.to_datetime
    end

    def now_with_mock_time
      mock_time || now_without_mock_time
    end

    alias_method :now, :now_with_mock_time
  end
end

module Kernel #:nodoc:
  alias_method :sleep_without_mock_time_scale, :sleep

  def sleep_with_mock_time_scale duration=nil
    mocked_time_stack_item = Timecop.scale_sleep? && Timecop.top_stack_item
    scaling_factor = 1.0
    scaling_factor *= mocked_time_stack_item.scaling_factor \
      if mocked_time_stack_item and mocked_time_stack_item.scaling_factor
    duration = duration / scaling_factor if duration
    sleep_without_mock_time_scale duration
  end

  alias_method :sleep, :sleep_with_mock_time_scale
end

class ConditionVariable #:nodoc:
  alias_method :wait_without_mock_time_scale, :wait

  def wait_with_mock_time_scale mutex, timeout=nil
    mocked_time_stack_item = Timecop.scale_sleep? && Timecop.top_stack_item
    scaling_factor = 1.0
    scaling_factor *= mocked_time_stack_item.scaling_factor \
      if mocked_time_stack_item and mocked_time_stack_item.scaling_factor
    timeout = timeout / scaling_factor if timeout
    wait_without_mock_time_scale mutex, timeout
  end

  alias_method :wait, :wait_with_mock_time_scale
end
