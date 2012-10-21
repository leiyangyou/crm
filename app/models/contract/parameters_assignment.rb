module ParametersAssignment

  def assign_parameters new_attributes
    return if new_attributes.blank?
    template = self.contract_template
    attributes = new_attributes.stringify_keys
    puts attributes
    multi_parameter_attributes = []
    attributes.each do |k, v|
      if k.include?("(")
        multi_parameter_attributes << [k, v]
      elsif respond_to?("#{k}=")
        send("#{k}=", v)
      elsif
        param = template.parameters[k]
        raise(ActiveRecord::UnknownAttributeError, "unknown attribute: #{k} for template '#{template.contract_type.name}'") unless param
        type = ContractTemplate::ParamType.get_type_by_name param.type
        param_value = type.convert v
        puts "assign #{k} with #{param_value}"
        self.parameters[k] = param_value
      end
    end
    assign_multiparameter_attributes(multi_parameter_attributes)
  end

  private
  def assign_multiparameter_attributes(pairs)
    execute_callstack_for_multiparameter_attributes(
        extract_callstack_for_multiparameter_attributes(pairs)
    )
  end
  def execute_callstack_for_multiparameter_attributes(callstack)
    errors = []
    callstack.each do |name, values_with_empty_parameters|
      begin
        if respond_to?("#{name}=")
          send :"#{name}=", read_attribute_value_from_parameter( name, values_with_empty_parameters)
        else
          self.parameters.send(name + "=", read_value_from_parameter(name, values_with_empty_parameters))
        end
      rescue => ex
        errors << ActiveRecord::AttributeAssignmentError.new("error on assignment #{values_with_empty_parameters.values.inspect} to #{name}", ex, name)
        raise ex
      end
    end
    unless errors.empty?
      raise ActiveRecord::MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
    end
  end
  def read_value_from_parameter(name, values_hash_from_param)
    param = contract_template.parameters[name]
    raise(UnknownAttributeError, "unknown attribute: #{k} for template '#{template.contract_type.name}'") unless param
    if values_hash_from_param.values.all?{|v|v.nil?}
      nil
    elsif param.type == 'date'
      read_date_parameter_value(name, values_hash_from_param)
    else
    end
  end
  def read_attribute_value_from_parameter(name, values_hash_from_param)
    klass = (self.class.reflect_on_aggregation(name.to_sym) || column_for_attribute(name)).klass
    if values_hash_from_param.values.all?{|v|v.nil?}
      nil
    elsif klass == Time
      read_time_parameter_value(name, values_hash_from_param)
    elsif klass == Date
      read_date_parameter_value(name, values_hash_from_param)
    else
      read_other_parameter_value(klass, name, values_hash_from_param)
    end
  end

  def read_date_parameter_value(name, values_hash_from_param)
    return nil if (1..3).any? {|position| values_hash_from_param[position].blank?}
    set_values = [values_hash_from_param[1], values_hash_from_param[2], values_hash_from_param[3]]
    begin
      Date.new(*set_values)
    rescue ArgumentError # if Date.new raises an exception on an invalid date
      instantiate_time_object(name, set_values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
    end
  end
  def read_time_parameter_value(name, values_hash_from_param)
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
  def read_other_parameter_value(klass, name, values_hash_from_param)
    max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param)
    values = (1..max_position).collect do |position|
      raise "Missing Parameter" if !values_hash_from_param.has_key?(position)
      values_hash_from_param[position]
    end
    klass.new(*values)
  end

  def extract_callstack_for_multiparameter_attributes(pairs)
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

  def type_cast_attribute_value(multiparameter_name, value)
    multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
  end

  def find_parameter_position(multiparameter_name)
    multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
  end
end