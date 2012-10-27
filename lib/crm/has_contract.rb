module CRM
  module HasContract
    def self.included base
      base.extend ClassMethod
    end

    module ClassMethod
      def has_contract name = nil
        name = self.name.to_url unless name
        @contract_type = name
        self.extend ContractTypeAccessor
      end
    end

    module ContractTypeAccessor
      attr_accessor :contract_type
    end
  end
end

