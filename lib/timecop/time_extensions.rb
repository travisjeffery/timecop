# DateSetter
# Allows us to "freeze" time in our Rails application.
# This is very useful when your app's functionality is dependent on time (e.g. 
# anything that might expire).  This will allow us to alter the return value of
# Date.today, Time.now, and DateTime.now, such that our application code _never_
# has to change.

class Time
  class << self
    # Time we might be behaving as
    attr_reader :mock_time
    
    # Set new time to pretend we are.
    def mock_time=(new_now)
      @mock_time = new_now
    end
    
    # now() with possible augmentation
    def now_with_mock_time
      mock_time || now_without_mock_time
    end
    alias_method_chain :now, :mock_time
  end
end 

class Date
  class << self
    # Date we might be behaving as
    attr_reader :mock_date
    
    # Set new date to pretend we are.
    def mock_date=(new_date)
      @mock_date = new_date
    end
    
    # today() with possible augmentation
    def today_with_mock_date
      mock_date || today_without_mock_date
    end
    alias_method_chain :today, :mock_date
  end
end

class DateTime
  class << self
    # Time we might be behaving as
    attr_reader :mock_time
    
    # Set new time to pretend we are.
    def mock_time=(new_now)
      @mock_time = new_now
    end
    
    # now() with possible augmentation
    def now_with_mock_time
      mock_time || now_without_mock_time
    end
    alias_method_chain :now, :mock_time
  end
end
