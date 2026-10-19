module DateStrptimeYearBoundaryScenarios
  #calling freeze and travel tests are making the date Time.local(1992,1,1)

  # Test for wday
  def test_date_strptime_year_boundary_with_day_of_week
    assert_equal Date.strptime('Thursday', '%A'), Date.new(1992, 1, 2)
    assert_equal Date.strptime('Monday', '%A'), Date.new(1991, 12, 30)
  end

  # Test for cwday
  def test_date_strptime_year_boundary_with_iso_day_of_week
    assert_equal Date.strptime('4', '%u'), Date.new(1992, 1, 2)
    assert_equal Date.strptime('1', '%u'), Date.new(1991, 12, 30)
  end

  # Test for wnum1
  def test_date_strptime_year_boundary_with_wnum1
    assert_equal Date.strptime('52', '%W'), Date.strptime('1992-52', '%Y-%W')
    assert_equal Date.strptime('1', '%W'), Date.strptime('1992-1', '%Y-%W')
  end

  # Test for wnum0
  def test_date_strptime_year_boundary_with_wnum0
    assert_equal Date.strptime('52', '%U'), Date.strptime('1992-52', '%Y-%U')
    assert_equal Date.strptime('1', '%U'), Date.strptime('1992-1', '%Y-%U')
  end

  # Test for cweek: without %G the ISO week-based year of the current date (1992) is used
  def test_date_strptime_year_boundary_with_cweek
    assert_equal Date.strptime('52', '%V'), Date.new(1992, 12, 21)
    assert_equal Date.strptime('1', '%V'), Date.new(1991, 12, 30)
  end
end
