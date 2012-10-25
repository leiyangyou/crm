module CRM
  module HasContract
    def self.included base
      base.extend ClassMethod
    end

    module ClassMethod
      attr_accessor :contract_type
      def has_contract name = nil
        name = self.name.to_url unless name
        @contract_type = name
      end
    end
  end
end

