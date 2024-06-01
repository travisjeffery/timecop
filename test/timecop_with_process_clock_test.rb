require_relative "test_helper"
require 'timecop'

class TestTimecopWithProcessClock < Minitest::Test
  TIME_EPSILON = 0.001 # seconds - represents enough time for Process.clock_gettime to have advanced if not frozen

  def teardown
    Timecop.return
  end

  if RUBY_VERSION >= '2.1.0'
    def test_process_clock_gettime_monotonic
      Timecop.freeze do
        assert_same(*consecutive_monotonic, "CLOCK_MONOTONIC is not frozen")
      end

      initial_time = monotonic
      Timecop.freeze(-0.5) do
        assert_operator(monotonic, :<, initial_time, "CLOCK_MONOTONIC is not traveling back in time")
      end
    end

    def test_process_clock_gettime_monotonic_nested
      Timecop.freeze do
        parent = monotonic

        sleep(TIME_EPSILON)

        delta = 0.5
        Timecop.freeze(delta) do
          child = monotonic
          assert_equal(child, parent + delta, "Nested freeze not working for monotonic time")
        end
      end
    end

    def test_process_clock_gettime_monotonic_travel
      initial_time = monotonic
      Timecop.travel do
        refute_same(*consecutive_monotonic, "CLOCK_MONOTONIC is frozen")
        assert_operator(monotonic, :>, initial_time, "CLOCK_MONOTONIC is not moving forward")
      end

      Timecop.travel(-0.5) do
        refute_same(*consecutive_monotonic, "CLOCK_MONOTONIC is frozen")
        assert_operator(monotonic, :<, initial_time, "CLOCK_MONOTONIC is not traveling properly")
      end
    end

    def test_process_clock_gettime_monotonic_scale
      scale = 4
      sleep_length = 0.25
      Timecop.scale(scale) do
        initial_time = monotonic
        sleep(sleep_length)
        expected_time = initial_time + (scale * sleep_length)
        assert_times_effectively_equal expected_time, monotonic, 0.1, "CLOCK_MONOTONIC is not scaling"
      end
    end

    def test_process_clock_gettime_realtime
      Timecop.freeze do
        assert_same(*consecutive_realtime, "CLOCK_REALTIME is not frozen")
      end

      initial_time = realtime
      Timecop.freeze(-20) do
        assert_operator(realtime, :<, initial_time, "CLOCK_REALTIME is not traveling back in time")
      end
    end

    def test_process_clock_gettime_realtime_travel
      initial_time = realtime
      Timecop.travel do
        refute_equal consecutive_realtime, "CLOCK_REALTIME is frozen"
        assert_operator(realtime, :>, initial_time, "CLOCK_REALTIME is not moving forward")
      end

      delta = 0.1
      Timecop.travel(Time.now - delta) do
        refute_equal consecutive_realtime, "CLOCK_REALTIME is frozen"
        assert_operator(realtime, :<, initial_time, "CLOCK_REALTIME is not traveling properly")
        sleep(delta)
        assert_operator(realtime, :>, initial_time, "CLOCK_REALTIME is not traveling properly")
      end
    end

    def test_process_clock_gettime_realtime_scale
      scale = 4
      sleep_length = 0.25
      Timecop.scale(scale) do
        initial_time = realtime
        sleep(sleep_length)
        assert_operator(initial_time + scale * sleep_length, :<, realtime, "CLOCK_REALTIME is not scaling")
      end
    end

    private

    def monotonic
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def realtime
      Process.clock_gettime(Process::CLOCK_REALTIME)
    end

    def consecutive_monotonic
      consecutive_times(:monotonic)
    end

    def consecutive_realtime
      consecutive_times(:realtime)
    end

    def consecutive_times(time_method)
      t1 = send(time_method)
      sleep(TIME_EPSILON)
      t2 = send(time_method)

      [t1, t2]
    end
  end
end
