module CRM
  module HasContract
    def self.included base
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def has_contract name = nil
        name = self.name.to_url unless name
        @contract_type = name
        self.extend ContractTypeAccessor
      end
    end

    module InstanceMethods
      def to_contract_params
        if respond_to? :attributes
          self.attributes
        else
          {}
        end
      end
    end

    module ContractTypeAccessor
      attr_accessor :contract_type
    end
  end
end

