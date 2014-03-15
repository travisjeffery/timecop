class Timecop
  module RSpec
    class Metadata

      def self.configure!
        ::RSpec.configure do |config|
          when_tagged_with_timecop = { :timecop => lambda { |v| !!v } }

          config.before(:each, when_tagged_with_timecop) do |ex|
            example = ex.example

            options = example.metadata[:timecop]
            begin
              Timecop.send(options[:mode], options[:time])
            rescue
              raise ArgumentError, 'Pass a hash like timecop: ' \
                                   '{ mode: :freeze, time: Time.local(1990) }'
            end
          end

          config.after(:each, when_tagged_with_timecop) do |ex|
            Timecop.return
          end
        end
      end

      def self.handle_errors(options)
        raise ArgumentError, 'missing :mode key' unless options.key?(:mode)
        raise ArgumentError, 'missing :time key' unless options.key?(:time)
        unless [:freeze, :travel, :scale].include?(options[:mode])
          raise ArgumentError, 'invalid mode, valid are :freeze, :travel and :scale'
        end
      end
    end
  end
end
