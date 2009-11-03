
class Timecop
  # A data class for carrying around "time movement" objects.  Makes it easy to keep track of the time
  # movements on a simple stack.
  class TimeStackItem #:nodoc:
  
    attr_reader :mock_type
    def initialize(mock_type, *args)
      @mock_type = mock_type
      arg = args.shift
      if arg.is_a?(Time)
        @time = arg.getlocal
      elsif Object.const_defined?(:DateTime) && arg.is_a?(DateTime)
        offset_difference = Time.now_without_mock_time.utc_offset - rational_to_utc_offset(arg.offset)
        @time = Time.local(arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec) + offset_difference
      elsif Object.const_defined?(:Date) && arg.is_a?(Date)
        @time = Time.local(arg.year, arg.month, arg.day, 0, 0, 0)
      elsif args.empty? && arg.kind_of?(Integer)
        @time = Time.now + arg
      else # we'll just assume it's a list of y/m/h/d/m/s
        year   = arg        || 0
        month  = args.shift || 1
        day    = args.shift || 1
        hour   = args.shift || 0
        minute = args.shift || 0
        second = args.shift || 0
        @time = Time.local(year, month, day, hour, minute, second)
      end
    end
    
    def year
      @time.year
    end
    
    def month
      @time.month
    end
    
    def day
      @time.day
    end
    
    def hour
      @time.hour
    end
    
    def min
      @time.min
    end
    
    def sec
      @time.sec
    end
    
    def time #:nodoc:
      @time
    end
    
    def date
      time.send(:to_date)
    end
    
    def datetime
      time.send(:to_datetime)
    end
    
    private
      def rational_to_utc_offset(rational)
        ((24.0 / rational.denominator) * rational.numerator) * (60 * 60)
      end
      
      def utc_offset_to_rational(utc_offset)
        Rational(utc_offset, 24 * 60 * 60)
      end
      
  end
end