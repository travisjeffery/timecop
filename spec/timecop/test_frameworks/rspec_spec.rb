require 'spec_helper'

describe TestFrameworks::RSpec do
  it 'freeze time with metadata', :freeze_time do
    Timecop.travel Time.new(2010, 01, 01)

    expect(Time.now).to have_attributes(
      year: 2010,
      month: 1,
      day: 1,
      hour: 0,
      min: 0,
      sec: 0
    )
  end

  context 'freeze and travel to time from metadata' do
    it 'with a string date', freeze_time: { at: '2010-01-01' } do
      expect(Time.now).to have_attributes(
        year: 2010,
        month: 1,
        day: 1,
        hour: 0,
        min: 0,
        sec: 0
      )
    end

    it 'with an object time', freeze_time: { at: Time.new(2010, 01, 01) } do
      expect(Time.now).to have_attributes(
        year: 2010,
        month: 1,
        day: 1,
        hour: 0,
        min: 0,
        sec: 0
      )
    end
  end

  context 'returns the time after the block ends' do
    it 'use freezed time', freeze_time: { at: '2010-01-01' } do
      expect(Time.now).to have_attributes(
        year: 2010,
        month: 1,
        day: 1,
        hour: 0,
        min: 0,
        sec: 0
      )
    end

    it 'does not use previous freezed time' do
      expect(Time.now).not_to have_attributes(
        year: 2010,
        month: 1,
        day: 1,
        hour: 0,
        min: 0,
        sec: 0
      )
    end
  end
end
