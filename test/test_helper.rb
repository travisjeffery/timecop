require 'test/unit'

class Test::Unit::TestCase
  private
    # Tests to see that two times are within the given distance,
    # in seconds, from each other.
    def times_effectively_equal(time1, time2, seconds_interval = 1)
      (time1 - time2).abs <= seconds_interval
    end
    
    def assert_times_effectively_equal(time1, time2, seconds_interval = 1, msg = nil)
      assert times_effectively_equal(time1, time2, seconds_interval), "#{msg}: time1 = #{time1.to_s}, time2 = #{time2.to_s}"
    end
    
    def assert_times_effectively_not_equal(time1, time2, seconds_interval = 1, msg = nil)
      assert !times_effectively_equal(time1, time2, seconds_interval), "#{msg}: time1 = #{time1.to_s}, time2 = #{time2.to_s}"
    end
    
    def local_offset
      DateTime.now_without_mock_time.offset
    end
  
    TIMEZONES = ["Europe/Paris", "UTC", "EDT"]
  
    def each_timezone
      old_tz = ENV["TZ"]
    
      begin
        TIMEZONES.each do |timezone|
          ENV["TZ"] = timezone
          yield
        end
      ensure
        ENV["TZ"] = old_tz
      end
    end
    
    def a_time_stack_item
      Timecop::TimeStackItem.new(:freeze, 2008, 1, 1, 0, 0, 0)
    end
  
    def assert_date_times_equal(dt1, dt2)
      assert_equal dt1, dt2, "Failed for timezone: #{ENV['TZ']}: #{dt1.to_s} not equal to #{dt2.to_s}"
    end
    
end