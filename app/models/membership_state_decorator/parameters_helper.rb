module MembershipStateDecorator
  module ParametersHelper
    def self.included base
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
    class ParameterDescriptor
      attr_accessor :name, :type, :required
      def initialize name, type, required = true
        @name = name
        @type = type
        @required = required
      end
    end
    class ParameterConverter
      include Singleton
      def convert(descriptor, value)
        type = descriptor.type
        if type == String
          return value
        elsif type == Integer
          return value.to_i
        elsif type == Date
          return convert_date_parameter_value(value)
        elsif type == Time
          return convert_time_parameter_value(value)
        else
          return nil
        end
      end

      private
      def convert_date_parameter_value value
        case value
          when Date
            return value
          when Time
            return value.to_date
          when String
            begin
              Date.parse(value)
            rescue ArgumentError
              return nil
            end
          when Hash
            return nil if (1..3).any? {|position| value[position].blank?}
            set_values = [value[1], value[2], value[3]]
            begin
              return Date.new(*set_values)
            rescue ArgumentError
              return nil
            end
          else
            return nil
        end
      end

      def convert_time_parameter_value value
        case value
          when Time
            return value
          when String
            begin
              Time.parse(value)
            rescue Argumenterror
              return nil
            end
          when Hash
            return nil if (1..3).any? {|position| value[position].blank?}
            max_position = value.keys.max
            set_values = (1..max_position).collect{|position| value[position]}
            begin
              return Time.local_time(set_values)
            rescue
              return nil
            end
          else
            return nil
        end
      end
    end
    class ParametersDescriptor
      def initialize
        @types = {}
      end

      def add_parameter( type, parameter)
        parameters = @types[type]
        unless parameters
          parameters = {}
          @types[type] = parameters
        end
        parameters[parameter.name] = parameter
      end

      def [] type
        @types[type]
      end
    end
    module ClassMethods
      def self.extended base
        base.instance_variable_set(:"@parameters_descriptor", ParametersDescriptor.new)
        base.instance_eval do
          def parameters_descriptor
            @parameters_descriptor
          end
        end
      end
      def type(type, &block)
        @current_type = type.to_s
        block.call
        @current_type = nil
      end

      def parameter( name, type, options = {})
        raise 'parameter should be put in the block of type' unless @current_type
        parameter_descriptor = ParameterDescriptor.new(name.to_s, type, options[:required] || true)
        @parameters_descriptor.add_parameter( @current_type, parameter_descriptor)
      end
    end

    module InstanceMethods
      def valid_parameter? name
        parameter_descriptor_for name
      end
      def parameter_descriptor_for name
        parameters_descriptor[name.to_s]
      end

      def parameters_descriptor
        self.class.parameters_descriptor[self.state_type] || {}
      end

      def convert_parameter(name, value)
        return nil unless value
        descriptor = parameter_descriptor_for name
        return nil unless descriptor
        ParameterConverter.instance.convert(descriptor, value)
      end

      def assign_parameters_attributes new_parameters
        multi_parameter_attributes = []
        parameters = new_parameters.stringify_keys
        parameters.each_pair do |key, value|
          if is_multipart_parameter(key)
            if valid_parameter?( extract_key_from_multipart_parameter(key))
              multi_parameter_attributes << [key, value]
            end
          else
            if valid_parameter? key
              self.parameters[key] = convert_parameter(key, value)
            end
          end
        end
        assign_multi_parameter_attributes(multi_parameter_attributes)
      end

      private
      def is_multipart_parameter key
        key.include?("(")
      end

      def extract_key_from_multipart_parameter key
        key[0...key.index("(")]
      end

      def assign_multi_parameter_attributes(pairs)
        execute_multi_parameter_assignment(
            extract_multi_parameter_attributes(pairs)
        )
      end

      def extract_multi_parameter_attributes(pairs)
        attributes = {}
        pairs.each do |pair|
          name, value = pair
          attr_name = name.split("(").first
          attributes[attr_name] = {} unless attributes.include?(attr_name)
          parameter_value = value.empty? ? nil : type_cast_attribute_value(name, value)
          attributes[attr_name][find_parameter_position(name)] ||= parameter_value
        end
        attributes
      end
      def execute_multi_parameter_assignment(attributes)
        attributes.each do |key, value|
          self.parameters[key] = convert_parameter(key, value)
        end
      end

      def type_cast_attribute_value(multiparameter_name, value)
        multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
      end

      def find_parameter_position(multiparameter_name)
        multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
      end
    end
  end
end