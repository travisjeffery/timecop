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
