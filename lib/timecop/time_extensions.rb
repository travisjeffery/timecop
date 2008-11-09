# 1. Extensions to the Time, Date, and DateTime objects
# 2. Allows us to "freeze" time in our Ruby applications.
# 3. This is very useful when your app's functionality is dependent on time (e.g. 
# anything that might expire).  This will allow us to alter the return value of
# Date.today, Time.now, and DateTime.now, such that our application code _never_ has to change.

class Time
  class << self
    # Time we might be behaving as
    attr_reader :mock_time
    
    # Set new time to pretend we are.
    def mock_time=(new_now)
      @mock_time = new_now
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

if Object.const_defined?(:Date)
  class Date
    class << self
      # Date we might be behaving as
      attr_reader :mock_date
    
      # Set new date to pretend we are.
      def mock_date=(new_date)
        @mock_date = new_date
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

if Object.const_defined?(:DateTime)
  class DateTime
    class << self
      # Time we might be behaving as
      attr_reader :mock_time
    
      # Set new time to pretend we are.
      def mock_time=(new_now)
        @mock_time = new_now
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
end