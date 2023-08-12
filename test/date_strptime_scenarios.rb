module DateStrptimeScenarios

  #calling freeze and travel tests are making the date Time.local(1984,2,28)

  def test_date_strptime_with_year
    assert_equal Date.strptime('1999', '%Y'), Date.new(1999, 1, 1)
  end

  def test_date_strptime_without_year
    assert_equal Date.strptime('04-14', '%m-%d'), Date.new(1984, 4, 14)
  end

  def test_date_strptime_without_day
    assert_equal Date.strptime('1999-04', '%Y-%m'), Date.new(1999, 4, 1)
  end

  def test_date_strptime_day_of_year_without_year
    assert_equal Date.strptime("153", '%j'), Date.new(1984, 6, 1)
  end

  def test_date_strptime_day_of_year_with_year
    assert_equal Date.strptime("1999 153", '%Y %j'), Date.new(1999, 6, 2)
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

  def test_date_strptime_with_commercial_week_date_and_day_of_week_from_sunday
    #2/27/1984 is a monday. wed the 29th is the last day of march.

    #1984-09 is 9th commercial week of 1984 starting on monday 2/27
    #specifying day of week = 0 with non-commercial day of week means
    #we jump to sunday, so 6 days after monday 2/27 which is 3/4
    assert_equal Date.strptime('1984-09-0', '%G-%V-%w'), Date.new(1984, 3, 04)
    assert_equal Date.strptime('1984-09-1', '%G-%V-%w'), Date.new(1984, 2, 27)
    assert_equal Date.strptime('1984-09-2', '%G-%V-%w'), Date.new(1984, 2, 28)
    assert_equal Date.strptime('1984-09-3', '%G-%V-%w'), Date.new(1984, 2, 29)
    assert_equal Date.strptime('1984-09-6', '%G-%V-%w'), Date.new(1984, 3, 03)

    #1984-09 is 9th commercial week of 1984 starting on a monday
    #specifying day of week = 1 with commercial day of week means stay at the 27th
    assert_equal Date.strptime('1984-09-1', '%G-%V-%u'), Date.new(1984, 2, 27)
    assert_equal Date.strptime('1984-09-2', '%G-%V-%u'), Date.new(1984, 2, 28)
    assert_equal Date.strptime('1984-09-3', '%G-%V-%u'), Date.new(1984, 2, 29)
    assert_equal Date.strptime('1984-09-7', '%G-%V-%u'), Date.new(1984, 3, 04)
  end

  def test_date_strptime_week_number_of_year_day_of_week_sunday_start
    assert_equal Date.strptime('1984 09 0', '%Y %U %w'), Date.new(1984, 2, 26)
  end

  def test_date_strptime_with_iso_8601_week_date
    assert_equal Date.strptime('1984-W09-1', '%G-W%V-%u'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_year_and_week_number_of_year
    assert_equal Date.strptime('201810', '%Y%W'), Date.new(2018, 3, 5)
  end

  def test_date_strptime_with_year_and_week_number_of_year_and_day_of_week_from_monday
    assert_equal Date.strptime('2018107', '%Y%W%u'), Date.new(2018, 3, 11)
  end

  def test_date_strptime_with_just_week_number_of_year
    assert_equal Date.strptime('14', '%W'), Date.new(1984, 4, 02)
  end

  def test_date_strptime_week_of_year_and_day_of_week_from_sunday
    assert_equal Date.strptime('140', '%W%w'), Date.new(1984, 4, 8)
  end

  def test_date_strptime_with_seconds_since_epoch
    assert_equal Date.strptime('446731200', '%s'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_miliseconds_since_epoch
    assert_equal Date.strptime('446731200000', '%Q'), Date.new(1984, 2, 27)
  end

  def test_date_strptime_with_invalid_date
    assert_raises(ArgumentError) { Date.strptime('', '%Y-%m-%d') }
  end

  def test_date_strptime_with_gregorian
    assert_equal Date.strptime('1999-04-01', '%Y-%m-%d', Date::GREGORIAN), Date.new(1999, 4, 1)
  end

  def test_date_strptime_with_gregorian_non_leap
    assert(!Date.strptime('1000-04-01', '%Y-%m-%d', Date::GREGORIAN).leap?)
  end

  def test_date_strptime_with_julian_leap
    assert(Date.strptime('1000-04-01', '%Y-%m-%d', Date::JULIAN).leap?)
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
        '%G %V %w',
        '%G %V %u',
        '%C %g %V %w',
        '%C %g %V %u',
        '%Y %W %w',
        '%Y %W %u',
        '%C %y %W %w',
        '%C %y %W %u',
        '%Y %U %w',
        '%Y %U %u',
        '%C %y %U %w',
        '%C %y %U %u',
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
