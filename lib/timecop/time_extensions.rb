
class Time #:nodoc:
  class << self
    # Time we are behaving as
    def mock_time
      mocked_time_stack_item = Timecop.top_stack_item
      mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.time
    end
    
    # Alias the original now
    alias_method :now_without_mock_time, :now

    # Define now_with_mock_time
    def now_with_mock_time
      mock_time || now_without_mock_time
    end
    
    # Alias now to now_with_mock_time
    alias_method :now, :now_with_mock_time
  end
end 

if Object.const_defined?(:Date) && Date.respond_to?(:today)
  class Date #:nodoc:
    class << self
      # Date we are behaving as
      def mock_date
        mocked_time_stack_item = Timecop.top_stack_item
        mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.date
      end
      
      # Alias the original today
      alias_method :today_without_mock_date, :today
    
      # Define today_with_mock_date
      def today_with_mock_date
        mock_date || today_without_mock_date
      end
    
      # Alias today to today_with_mock_date
      alias_method :today, :today_with_mock_date
    end
  end
end

if Object.const_defined?(:DateTime) && DateTime.respond_to?(:now)
  class DateTime #:nodoc:
    class << self
      # Time we are behaving as
      def mock_time
        mocked_time_stack_item = Timecop.top_stack_item
        mocked_time_stack_item.nil? ? nil : mocked_time_stack_item.datetime
      end
      
      # Fake alias :now_without_mock_time :now
      # It appears that the DateTime library itself references Time.now
      # for it's interpretation of now which caused 
      # DateTime.now_without_mock_time to incorrectly return the frozen time.
      def now_without_mock_time
        Time.now_without_mock_time.send :to_datetime
      end
      
      # Define now_with_mock_time
      def now_with_mock_time
        mock_time || now_without_mock_time
      end

      # Alias now to now_with_mock_time
      alias_method :now, :now_with_mock_time
    end
  end
end