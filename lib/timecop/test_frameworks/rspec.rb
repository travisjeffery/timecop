module TestFrameworks
  module RSpec
    # Easily freeze time using RSpec metadata
    # It automatically returns the time at the end of the test
    #
    # Freezing time to just trevel inside the test
    # it 'description', :freeze_time do
    #   Timecop.trevel some_date
    # end
    #
    # Freezing and treveling to specific time directly from metadata
    # it 'description', freeze_time: { at: some_date }
    # end
    def self.configure_metadata
      ::RSpec.configure do |config|
        config.around(:each, :freeze_time) do |example|
          if example.metadata[:freeze_time].is_a?(Hash)
            options = example.metadata[:freeze_time]
            Timecop.freeze(options[:at]) { example.run }
          else
            Timecop.freeze { example.run }
          end
        end
      end
    end
  end
end
