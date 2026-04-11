module DateTimeParseScenarios

  def test_date_time_parse_sunday_after_travel
    assert_equal DateTime.parse("2008-08-31"), DateTime.parse('Sunday')
    assert_equal DateTime.parse("2008-08-31"), DateTime.parse('Sun')
  end

  def test_date_time_parse_monday_after_travel
    assert_equal DateTime.parse("2008-09-01"), DateTime.parse('Monday')
    assert_equal DateTime.parse("2008-09-01"), DateTime.parse('Mon')
  end

  def test_date_time_parse_tuesday_after_travel
    assert_equal DateTime.parse("2008-09-02"), DateTime.parse('Tuesday')
    assert_equal DateTime.parse("2008-09-02"), DateTime.parse('Tue')
  end

  def test_date_time_parse_wednesday_after_travel
    assert_equal DateTime.parse("2008-09-03"), DateTime.parse('Wednesday')
    assert_equal DateTime.parse("2008-09-03"), DateTime.parse('Wed')
  end

  def test_date_time_parse_thursday_after_travel
    assert_equal DateTime.parse("2008-09-04"), DateTime.parse('Thursday')
    assert_equal DateTime.parse("2008-09-04"), DateTime.parse('Thu')
  end

  def test_date_time_parse_friday_after_travel
    assert_equal DateTime.parse("2008-09-05"), DateTime.parse('Friday')
    assert_equal DateTime.parse("2008-09-05"), DateTime.parse('Fri')
  end

  def test_date_time_parse_saturday_after_travel
    assert_equal DateTime.parse("2008-09-06"), DateTime.parse('Saturday')
    assert_equal DateTime.parse("2008-09-06"), DateTime.parse('Sat')
  end

  def test_date_time_parse_with_additional_args
    assert_equal DateTime.parse("2008-09-06", false), DateTime.parse('Saturday')
    assert_equal DateTime.parse("2008-09-06", false), DateTime.parse('Sat')
  end

  def test_date_time_parse_10
    assert_equal DateTime.parse("2008-09-10"), DateTime.parse('10')
  end

  def test_date_time_parse_october_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('October 10')
  end

  def test_date_time_parse_1010
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('1010')
  end

  def test_date_time_parse_10_slash_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('10/10')
  end

  def test_date_time_parse_Date_10_slash_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('Date 10/10')
  end

  def test_date_time_parse_time_only_scenario
    assert_equal DateTime.parse("2008-09-01T15:00:00"), DateTime.parse('15:00:00')
  end

  def test_date_time_parse_hhmm_uses_frozen_date_not_real_clock
    real_now = Time.now_without_mock_time.utc
    offset = 12 * 3600 + 30
    freeze_time = real_now.hour >= 12 ? real_now - offset : real_now + offset

    Timecop.freeze(freeze_time) do
      expected = DateTime.new(freeze_time.year, freeze_time.month, freeze_time.day, 1, 0, 0, 0)
      assert_equal expected, DateTime.parse('01:00')
    end
  end

  def test_date_time_parse_hhmm_format_returns_correct_time
    assert_equal DateTime.new(2008, 9, 1, 0, 0, 0), DateTime.parse('00:00')
    assert_equal DateTime.new(2008, 9, 1, 1, 0, 0), DateTime.parse('01:00')
    assert_equal DateTime.new(2008, 9, 1, 12, 30, 0), DateTime.parse('12:30')
    assert_equal DateTime.new(2008, 9, 1, 23, 59, 0), DateTime.parse('23:59')
  end

  def test_date_time_parse_month_year
    assert_equal DateTime.parse("2012-12-01"), DateTime.parse('DEC 2012')
  end

  def test_date_time_parse_wday_with_hour
    assert_equal DateTime.parse("2008-09-06T13:00:00"), DateTime.parse('Saturday 13:00')
  end

  def test_date_time_parse_non_string_raises_expected_error
    assert_raises(TypeError) { DateTime.parse(Object.new) }
  end

  def test_datetime_parse_nil_raises_type_error
    assert_raises(TypeError) { DateTime.parse(nil) }
  end
end
