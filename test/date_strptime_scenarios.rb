module DateStrptimeScenarios

  def test_date_strptime_without_year
    assert_equal Date.strptime('04-14', '%m-%d'), Date.new(1984, 4, 14)
  end

  def test_date_strptime_without_day
    assert_equal Date.strptime('1999-04', '%Y-%m'), Date.new(1999, 4, 1)
  end

  def test_date_strptime_without_specifying_format
    assert_equal Date.strptime('1999-04-14'), Date.new(1999, 4, 14)
  end

  def test_date_strptime_with_day_of_week
    assert_equal Date.strptime('Thursday', '%A'), Date.new(1984, 3, 1)
    assert_equal Date.strptime('Monday', '%A'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_invalid_date
    assert_raises(ArgumentError) { Date.strptime('', '%Y-%m-%d') }
  end

  def test_ancient_strptime
    ancient = Date.strptime('11-01-08', '%Y-%m-%d').strftime
    assert_equal '0011-01-08', ancient # Failed before fix to strptime_with_mock_date
  end

end
