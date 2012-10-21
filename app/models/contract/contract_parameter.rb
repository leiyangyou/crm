module ContractParameter

  def self.included base
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  module ClassMethods
    def contract_parameter *names
      names.each do |name|
        column = self.columns_hash[name.to_s]
        raise "Missing Parameter '#{name}'" unless column
        contract_parameters[name.to_s] =
            case column.type
              when :datetime
                ContractTemplate::Param.new :name => name.to_s, :type => 'date'
              when :integer
                ContractTempalte::Param.new :name => name.to_s, :type => 'number'
              when :string
                ContractTempalte::Param.new :name => name.to_s, :type => 'string'
              when :text
                ContractTempalte::Param.new :name => name.to_s, :type => 'text'
            end
      end
    end
    def contract_parameters
      @contract_parameters = @contract_parameters || {}
    end
  end

  module InstanceMethods
    def contract_parameters
      self.class.contract_parameters.reduce({}) do |result, pair|
        name = pair[0]
        result[name] = self.send(:"#{name}")
        result
      end
    end
  end
end