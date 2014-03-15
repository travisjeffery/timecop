require "spec_helper"

Timecop.configure_rspec_metadata!

describe Timecop::RSpec::Metadata do

  let(:freeze_time) do
    Time.local(2001, 01, 01)
  end

  describe 'with freeze' do

    it 'freeze the correct time', timecop: { mode: :freeze, time: Time.local(2001, 01, 01) } do
      expect(Time.now).to eq(freeze_time)
    end
  end

  describe 'with travel' do

    it 'freeze the correct time', timecop: { mode: :travel, time: Time.local(2001, 01, 01) } do
      expect(Time.now).to_not eq(freeze_time)
    end
  end

  describe 'with scale' do

    it 'freeze the correct time', timecop: { mode: :scale, time: 3600 } do
      expect(Time.now).to_not eq(freeze_time)
    end
  end

  describe 'without the metadata' do

    it 'freeze the correct time' do
      expect(Time.now).to_not eq(freeze_time)
    end
  end

  describe 'works at group level', timecop: { mode: :freeze, time: Time.local(2001, 01, 01) } do

    it 'freeze the time for one example' do
      expect(Time.now).to eq(freeze_time)
    end

    it 'freeze the time for another example' do
      expect(Time.now).to eq(freeze_time)
    end
  end

  describe 'always reset the time' do

    it 'freeze the correct time', timecop: { mode: :freeze, time: Time.local(2001, 01, 01) } do
      expect(Time.now).to eq(freeze_time)
    end

    it 'dont have the time freezed' do
      expect(Time.now).to_not eq(freeze_time)
    end
  end

  describe Timecop::RSpec::Metadata::TimecopCaller do

    describe '#call' do

      subject do
        Timecop::RSpec::Metadata::TimecopCaller.new(options)
      end

      describe 'handle of errors' do

        context 'with missing mode' do

          let(:options) do
            { time: 3600 }
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, 'missing :mode key')
          end
        end

        context 'with missing time' do

          let(:options) do
            { mode: :freeze }
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, 'missing :time key')
          end
        end

        context 'with invalid mode' do

          let(:options) do
            { mode: :wrong, time: 3600 }
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, 'invalid mode, valid are :freeze, ' \
                                              ':travel and :scale')
          end
        end

        context 'with invalid time' do

          let(:options) do
            { mode: :freeze, time: 'wrong' }
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, 'no time information in "wrong"')
          end
        end
      end
    end
  end
end
