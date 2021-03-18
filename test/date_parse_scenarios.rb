module DateParseScenarios

  def test_date_parse_sunday_after_travel
    assert_equal Date.parse("2008-08-31"), Date.parse('Sunday')
    assert_equal Date.parse("2008-08-31"), Date.parse('Sun')
  end

  def test_date_parse_monday_after_travel
    assert_equal Date.parse("2008-09-01"), Date.parse('Monday')
    assert_equal Date.parse("2008-09-01"), Date.parse('Mon')
  end

  def test_date_parse_tuesday_after_travel
    assert_equal Date.parse("2008-09-02"), Date.parse('Tuesday')
    assert_equal Date.parse("2008-09-02"), Date.parse('Tue')
  end

  def test_date_parse_wednesday_after_travel
    assert_equal Date.parse("2008-09-03"), Date.parse('Wednesday')
    assert_equal Date.parse("2008-09-03"), Date.parse('Wed')
  end

  def test_date_parse_thursday_after_travel
    assert_equal Date.parse("2008-09-04"), Date.parse('Thursday')
    assert_equal Date.parse("2008-09-04"), Date.parse('Thu')
  end

  def test_date_parse_friday_after_travel
    assert_equal Date.parse("2008-09-05"), Date.parse('Friday')
    assert_equal Date.parse("2008-09-05"), Date.parse('Fri')
  end

  def test_date_parse_saturday_after_travel
    assert_equal Date.parse("2008-09-06"), Date.parse('Saturday')
    assert_equal Date.parse("2008-09-06"), Date.parse('Sat')
  end

  def test_date_parse_with_additional_args
    assert_equal Date.parse("2008-09-06", false), Date.parse('Saturday')
    assert_equal Date.parse("2008-09-06", false), Date.parse('Sat')
  end

  def test_date_parse_10
    assert_equal Date.parse("2008-09-10"), Date.parse('10')
  end

  def test_date_parse_october_10
    assert_equal Date.parse("2008-10-10"), Date.parse('October 10')
  end

  def test_date_parse_1010
    assert_equal Date.parse("2008-10-10"), Date.parse('1010')
  end

  def test_date_parse_10_slash_10
    assert_equal Date.parse("2008-10-10"), Date.parse('10/10')
  end

  def test_date_parse_Date_10_slash_10
    assert_equal Date.parse("2008-10-10"), Date.parse('Date 10/10')
  end

  def test_date_parse_month_year
    assert_equal Date.parse("2012-12-01"), Date.parse('DEC 2012')
  end

  def test_date_parse_nil_raises_type_error
    assert_raises(TypeError) { Date.parse(nil) }
  end

  def test_date_parse_non_string_raises_expected_error
    assert_raises(TypeError) { Date.parse(Object.new) }
  end
end
