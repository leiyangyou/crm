module ContractDecorator
  module ContractFields
    def self.included base
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end


    class FieldBuilder
      attr_accessor :target
      def initialize target, &block
        @target = target
        instance_eval &block
      end
      def date *names
        options = names.extract_options!
        names.each{|name| target.register name, Contract::FieldTypes::DATE, options}
      end
      def number *names
        options = names.extract_options!
        names.each{|name| target.register name, Contract::FieldTypes::NUMBER, options}
      end
      def text *names
        options = names.extract_options!
        names.each{|name| target.register name, Contract::FieldTypes::TEXT, options}
      end
      def string *names
        options = names.extract_options!
        names.each{|name| target.register name, Contract::FieldTypes::STRING, options}
      end
    end

    class Field
      attr_accessor :name, :type, :options

      def initialize name, type, options = {}
        @name = name.to_s
        @type = type
        @options = options.stringify_keys!
      end

      def required?
        options['required']
      end

      def default
        options['default']
      end

      def options
        @options ||= {}
      end
    end
    module ClassMethods
      def fields
        @fields ||= {}
      end

      def field_for name
        fields[name.to_s]
      end

      def register name, type, options = {}
        fields[name.to_s] = Field.new( name, type, options)
        self.attr_accessible name.to_sym
        self.class_eval <<-END, __FILE__, __LINE__ + 1
        def #{name}
          parameters['#{name}'] || self.class.field_for('#{name}').default
        end
        def #{name}= value
          assign_field('#{name}', value)
        end
        END
      end

      def type_for name
        field = field_for name
        field && field.type
      end
      def parameter_fields &block
        FieldBuilder.new self, &block
      end
    end
    module InstanceMethods
      def assign_field name, value
        self.assign_fields :"#{name}"=> value
      end

      def assign_fields new_attributes
        return if new_attributes.blank?
        attributes = new_attributes.stringify_keys
        multi_parameter_fields = []
        attributes.each do |k, v|
          if k.include?("(")
            multi_parameter_fields << [k, v]
          elsif field = self.class.field_for(k)
            converter = FieldValueConverter.converter_for field.type
            field_value = converter.convert v
            self.parameters[k] = field_value
          end
        end
        assign_multiparameter_fields(multi_parameter_fields)
      end

      private
      def assign_multiparameter_fields(pairs)
        execute_callstack_for_multiparameter_fields(
            extract_callstack_for_multiparameter_fields(pairs)
        )
      end
      def execute_callstack_for_multiparameter_fields(callstack)
        errors = []
        callstack.each do |name, values_with_empty_parameters|
          begin
            self.parameters[name] = read_value_from_parameter_field(name, values_with_empty_parameters)
          rescue => ex
            errors << ActiveRecord::AttributeAssignmentError.new("error on assignment #{values_with_empty_parameters.values.inspect} to #{name}", ex, name)
            raise ex
          end
        end
        unless errors.empty?
          raise ActiveRecord::MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
        end
      end
      def read_value_from_parameter_field(name, values_hash_from_param)
        field = self.class.field_for name
        raise("unknown field: #{name} for contract '#{self.class}'") unless field
        if values_hash_from_param.values.all?{|v|v.nil?}
          nil
        elsif param.type == Contract::FieldTypes::DATE
          read_date_parameter_value(name, values_hash_from_param)
        else
        end
      end

      def read_date_parameter_field_value(name, values_hash_from_param)
        return nil if (1..3).any? {|position| values_hash_from_param[position].blank?}
        set_values = [values_hash_from_param[1], values_hash_from_param[2], values_hash_from_param[3]]
        begin
          Date.new(*set_values)
        rescue ArgumentError # if Date.new raises an exception on an invalid date
          instantiate_time_object(name, set_values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
        end
      end
      def read_time_parameter_field_value(name, values_hash_from_param)
        # If Date bits were not provided, error
        raise "Missing Parameter" if [1,2,3].any?{|position| !values_hash_from_param.has_key?(position)}
        max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param, 6)
        # If Date bits were provided but blank, then return nil
        return nil if (1..3).any? {|position| values_hash_from_param[position].blank?}

        set_values = (1..max_position).collect{|position| values_hash_from_param[position] }
        # If Time bits are not there, then default to 0
        (3..5).each {|i| set_values[i] = set_values[i].blank? ? 0 : set_values[i]}
        instantiate_time_object(name, set_values)
      end

      def extract_callstack_for_multiparameter_fields(pairs)
        attributes = { }
        pairs.each do |pair|
          multiparameter_name, value = pair
          attribute_name = multiparameter_name.split("(").first
          attributes[attribute_name] = {} unless attributes.include?(attribute_name)

          parameter_value = value.empty? ? nil : type_cast_attribute_value(multiparameter_name, value)
          attributes[attribute_name][find_parameter_position(multiparameter_name)] ||= parameter_value
        end

        attributes
      end
    end
  end
end