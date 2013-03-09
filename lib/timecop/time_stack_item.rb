class Timecop
    # A data class for carrying around "time movement" objects.  Makes it easy to keep track of the time
    # movements on a simple stack.
    class TimeStackItem #:nodoc:
      attr_reader :mock_type

      def initialize(mock_type, *args)
        raise "Unknown mock_type #{mock_type}" unless [:freeze, :travel, :scale].include?(mock_type)
        @scaling_factor = args.shift if mock_type == :scale
        @mock_type      = mock_type
        @time           = parse_time(*args)
        @time_was       = Time.now_without_mock_time
        @travel_offset  = compute_travel_offset
        @dst_adjustment = compute_dst_adjustment(@time)
      end

      def year
        time.year
      end

      def month
        time.month
      end

      def day
        time.day
      end

      def hour
        time.hour
      end

      def min
        time.min
      end

      def sec
        time.sec
      end

      def utc_offset
        time.utc_offset
      end

      def travel_offset
        @travel_offset
      end

      def scaling_factor
        @scaling_factor
      end

      def time(klass = time_klass) #:nodoc:
        begin
          actual_time = klass.at(@time)
          calculated_time = klass.at(@time.to_f)
          time = times_are_equal_within_epsilon(actual_time, calculated_time, 1) ? actual_time : calculated_time
        rescue
          time = klass.at(@time.to_f)
        end

        if travel_offset.nil?
          time
        elsif scaling_factor.nil?
          klass.at(Time.now_without_mock_time + travel_offset)
        else
          klass.at(scaled_time)
        end
      end

      def scaled_time
        (@time + (Time.now_without_mock_time - @time_was) * scaling_factor).to_f
      end

      def date(date_klass = Date)
        date_klass.jd(time.__send__(:to_date).jd)
      end

      def datetime(datetime_klass = DateTime)
        our_offset = utc_offset + dst_adjustment

        if Float.method_defined?(:to_r)
          fractions_of_a_second = time.to_f % 1
          datetime_klass.new(year, month, day, hour, min, sec + fractions_of_a_second, utc_offset_to_rational(our_offset))
        else
          our_offset = utc_offset + dst_adjustment
          datetime_klass.new(year, month, day, hour, min, sec, utc_offset_to_rational(our_offset))
        end
      end

      def dst_adjustment
        @dst_adjustment
      end

      private

      def rational_to_utc_offset(rational)
        ((24.0 / rational.denominator) * rational.numerator) * (60 * 60)
      end

      def utc_offset_to_rational(utc_offset)
        Rational(utc_offset, 24 * 60 * 60)
      end

      def parse_time(*args)
        arg = args.shift
        if arg.is_a?(Time)
          if Timecop.active_support != false && arg.respond_to?(:in_time_zone)
            arg.in_time_zone
          else
            arg.getlocal
          end
        elsif Object.const_defined?(:DateTime) && arg.is_a?(DateTime)
          expected_time = time_klass.local(arg.year, arg.month, arg.day, arg.hour, arg.min, arg.sec)
          expected_time += expected_time.utc_offset - rational_to_utc_offset(arg.offset)
          expected_time + compute_dst_adjustment(expected_time)
        elsif Object.const_defined?(:Date) && arg.is_a?(Date)
          time_klass.local(arg.year, arg.month, arg.day, 0, 0, 0)
        elsif args.empty? && arg.kind_of?(Integer)
          Time.now + arg
        elsif arg.nil?
          Time.now
        else
          if arg.is_a?(String) && Timecop.active_support != false && Time.respond_to?(:parse)
            Time.parse(arg)
          else
            # we'll just assume it's a list of y/m/d/h/m/s
            year   = arg        || 2000
            month  = args.shift || 1
            day    = args.shift || 1
            hour   = args.shift || 0
            minute = args.shift || 0
            second = args.shift || 0
            time_klass.local(year, month, day, hour, minute, second)
          end
        end
      end

      def compute_dst_adjustment(time)
        return 0 if !(time.dst? ^ Time.now.dst?)
        return -1 * 60 * 60 if time.dst?
        return 60 * 60
      end

      def compute_travel_offset
        return nil if mock_type == :freeze
        time - Time.now_without_mock_time
      end

      def times_are_equal_within_epsilon t1, t2, epsilon_in_seconds
        (t1 - t2).abs < epsilon_in_seconds
      end

      def time_klass
        Time.respond_to?(:zone) && Time.zone ? Time.zone : Time
      end
    end
  end
