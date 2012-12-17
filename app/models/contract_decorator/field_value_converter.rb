module ContractDecorator
  module FieldValueConverter
    def self.converter_for type
      converters[type]
    end

    def self.converters
      @converters ||= {}
    end
    class Base

      def self.for_type type
        FieldValueConverter.converters[type] = self.new
      end
      def convert value, default = nil
      end
    end

    class StringConverter < Base
      for_type Contract::FieldTypes::STRING
      for_type Contract::FieldTypes::TEXT
      def convert value, default = nil
        value.to_s
      end
    end

    class DateConverter < Base
      for_type Contract::FieldTypes::DATE
      def convert value, default = Date.today
        begin
          Date.parse(value)
        rescue Exception => e
          default
        end
      end
    end

    class NumberConverter < Base
      for_type Contract::FieldTypes::NUMBER
      def convert value, default = 0
        if value.respond_to?(:to_i)
          value.to_i
        else
          default
        end
      end
    end
  end
end