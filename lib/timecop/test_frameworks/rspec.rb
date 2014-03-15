class Timecop
  module RSpec
    class Metadata

      def self.configure!
        ::RSpec.configure do |config|
          when_tagged_with_timecop = { :timecop => lambda { |v| !!v } }

          config.before(:each, when_tagged_with_timecop) do |ex|
            example = ex.example
            options = example.metadata[:timecop]
            TimecopCaller.new(options).call
          end

          config.after(:each, when_tagged_with_timecop) do |ex|
            Timecop.return
          end
        end
      end

      class TimecopCaller

        VALID_MODES = [:freeze, :travel, :scale]

        def initialize(options)
          @options = options
        end

        def call
          handle_errors
          Timecop.send(options[:mode], options[:time])
        end

        private
          attr_reader :options

          def handle_errors
            missing_key?(:mode)
            missing_key?(:time)
            unless VALID_MODES.include?(options[:mode])
              raise ArgumentError, 'invalid mode, valid are :freeze, :travel and :scale'
            end
          end

          def missing_key?(key)
            raise ArgumentError, "missing :#{key} key" unless options.key?(key)
          end
      end
    end
  end
end
