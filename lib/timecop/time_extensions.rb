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

      d = Date._strptime(str, fmt) || Date.strptime_without_mock_date(str, fmt)
      now = Time.now.to_date
      year = d[:year] || now.year
      mon = d[:mon] || now.mon
      if d[:mday]
        Date.new(year, mon, d[:mday])
      elsif d[:wday]
        Date.new(year, mon, now.mday) + (d[:wday] - now.wday)
      else
        Date.new(year, mon, now.mday)
      end
    end

    alias_method :strptime, :strptime_with_mock_date

    def parse_with_mock_date(*args)
      parsed_date = parse_without_mock_date(*args)
      return parsed_date unless mocked_time_stack_item
      date_hash = Date._parse(*args)

      case
      when date_hash[:year] && date_hash[:mon]
        parsed_date
      when date_hash[:mon] && date_hash[:mday]
        Date.new(mocked_time_stack_item.year, date_hash[:mon], date_hash[:mday])
      when date_hash[:wday]
        closest_wday(date_hash[:wday])
      else
        parsed_date + mocked_time_stack_item.travel_offset_days
      end
    end

    alias_method :parse_without_mock_date, :parse
    alias_method :parse, :parse_with_mock_date

    def mocked_time_stack_item
      Timecop.top_stack_item
    end

    def closest_wday(wday)
      today = Date.today
      result = today - today.wday
      result += 1 until wday == result.wday
      result
    end
  end
end

class DateTime #:nodoc:
  class << self
    def mock_time
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.datetime(self)
    end

    def now_with_mock_time
      mock_time || now_without_mock_time
    end

    alias_method :now_without_mock_time, :now

    alias_method :now, :now_with_mock_time

    def parse_with_mock_date(*args)
      date_hash = Date._parse(*args)
      parsed_date = parse_without_mock_date(*args)
      return parsed_date unless mocked_time_stack_item
      date_hash = DateTime._parse(*args)

      case
      when date_hash[:year] && date_hash[:mon]
        parsed_date
      when date_hash[:mon] && date_hash[:mday]
        DateTime.new(mocked_time_stack_item.year, date_hash[:mon], date_hash[:mday])
      when date_hash[:wday]
        Date.closest_wday(date_hash[:wday]).to_datetime
      else
        parsed_date + mocked_time_stack_item.travel_offset_days
      end
    end

    alias_method :parse_without_mock_date, :parse
    alias_method :parse, :parse_with_mock_date

    def mocked_time_stack_item
      Timecop.top_stack_item
    end
  end
end

module Process #:nodoc:
  class << self
    alias_method :clock_gettime_without_mock, :clock_gettime

    def clock_gettime_mock_time(clock_id, unit = :float_second)
      mock_time = case clock_id
                  when Process::CLOCK_MONOTONIC
                    mock_time_monotonic
                  when Process::CLOCK_REALTIME
                    mock_time_realtime
                  end

      return clock_gettime_without_mock(clock_id, unit) unless mock_time

      divisor = case unit
                when :float_second
                  1_000_000_000.0
                when :second
                  1_000_000_000
                when :float_millisecond
                  1_000_000.0
                when :millisecond
                  1_000_000
                when :float_microsecond
                  1000.0
                when :microsecond
                  1000
                when :nanosecond
                  1
                end

      (mock_time / divisor)
    end

    alias_method :clock_gettime, :clock_gettime_mock_time

    private

    def mock_time_monotonic
      mocked_time_stack_item = Timecop.top_stack_item
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.monotonic
    end

    def mock_time_realtime
      mocked_time_stack_item = Timecop.top_stack_item

      return nil if mocked_time_stack_item.nil?

      t = mocked_time_stack_item.time
      t.to_i * 1_000_000_000 + t.nsec
    end
  end
end

