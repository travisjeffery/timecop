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
