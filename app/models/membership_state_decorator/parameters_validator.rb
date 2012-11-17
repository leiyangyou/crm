module MembershipStateDecorator
  class ParametersValidator < ActiveModel::Validator
    def validate(record)
      parameters = record.parameters
      record.parameters_descriptor.each do |key, value|
        parameter = parameters[key]
        record.errors.add(:parameters, :parameter_is_required, :name => key) unless parameter
      end
    end
  end
end