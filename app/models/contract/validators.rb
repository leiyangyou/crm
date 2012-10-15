module Contract::Validators
  class ContractParametersValidator < ActiveModel::Validator
    def validate(record)
      template = self.contract_template
      parameters = record.parameters
      template.parameters.each do |key, param|
        type = ContractTemplate::ParamType.get_type_by_name(param.type)
        param_value = parameters[key.to_s]
        unless param_value.type == param.type
          parameters.error.add(:"#{key}", :param_type_error, :got => param_value.type, :expected => param.type)
          next
        end
        unless type.validate param_value.value
          parameters.error.add(:"#{key}", :param_value_error, :type => type.name)
          next
        end
      end
    end
  end
end