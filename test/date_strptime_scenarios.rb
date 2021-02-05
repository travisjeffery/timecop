module DateStrptimeScenarios

  #calling freeze and travel tests are making the date Time.local(1984,2,28)
  def test_date_strptime_without_year
    assert_equal Date.strptime('04-14', '%m-%d'), Date.new(1984, 4, 14)
  end

  def test_date_strptime_without_day
    assert_equal Date.strptime('1999-04', '%Y-%m'), Date.new(1999, 4, 1)
  end

  def test_date_strptime_day_of_year_without_year
    assert_equal Date.strptime("153", '%j'), Date.new(1984, 6, 1)
  end

  def test_date_strptime_without_specifying_format
    assert_equal Date.strptime('1999-04-14'), Date.new(1999, 4, 14)
  end

  def test_date_strptime_with_day_of_week
    assert_equal Date.strptime('Thursday', '%A'), Date.new(1984, 3, 1)
    assert_equal Date.strptime('Monday', '%A'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_commercial_week_date
    assert_equal Date.strptime('1984-09', '%G-%V'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_iso_8601_week_date
    assert_equal Date.strptime('1984-W09-1', '%G-W%V-%u'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_invalid_date
    assert_raises(ArgumentError) { Date.strptime('', '%Y-%m-%d') }
  end

  def test_ancient_strptime
    ancient = Date.strptime('11-01-08', '%Y-%m-%d').strftime
    assert_equal '0011-01-08', ancient # Failed before fix to strptime_with_mock_date
  end

  def test_strptime_defaults_correctly
    assert_equal(Date.new, Date.strptime)
  end

  def test_strptime_from_date_to_s
    d = Date.new(1984, 3, 1)
    assert_equal(d, Date.strptime(d.to_s))
  end

  def test_strptime_converts_back_and_forth_between_date_and_string_for_many_formats_every_day_of_the_year
    (Date.new(2006,6,1)..Date.new(2007,6,1)).each do |d|
      [
        '%Y %m %d',
        '%C %y %m %d',

        '%Y %j',
        '%C %y %j',

        #TODO Support these formats
        # '%G %V %w',
        # '%G %V %u',
        # '%C %g %V %w',
        # '%C %g %V %u',

        # '%Y %U %w',
        # '%Y %U %u',
        # '%Y %W %w',
        # '%Y %W %u',
        # '%C %y %U %w',
        # '%C %y %U %u',
        # '%C %y %W %w',
        # '%C %y %W %u',
      ].each do |fmt|
        s = d.strftime(fmt)
        d2 = Date.strptime(s, fmt)
        assert_equal(d, d2, [fmt, d.to_s, d2.to_s].inspect)
      end

    end
  end

  def test_strptime_raises_when_unparsable
    assert_raises(ArgumentError) do
      Date.strptime('')
    end
    assert_raises(ArgumentError) do
      Date.strptime('2001-02-29', '%F')
    end
    assert_raises(ArgumentError) do
      Date.strptime('01-31-2011', '%m/%d/%Y')
    end
  end

  def test_strptime_of_time_string_raises
    #TODO: this is a bug
    skip("TODO: broken contract")
    assert_raises(ArgumentError) do
      Date.strptime('23:55', '%H:%M')
    end
  end

end
