module CRM
  module Contractable

    def self.instance_based? contract
      HasContract.responder_for contract
    end

    def self.class_based? contract
      FromContract.responder_for contract
    end

    module HasContract
      def self.register_responder contract_class, responder
        responder.send :include, Responder unless responder < Responder
        responders[contract_class.to_s] = responder
      end

      def self.responder_for contract
        responders[contract.class.to_s]
      end

      def self.responders
        @responders ||= {}
      end
      module Responder
        def self.included base
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end
      end

      module InstanceMethods
        def contract_signed contract
          raise "has_contract requires the model to implement the instance method contract_signed"
        end
      end

      module ClassMethods
        def from_contract contract
          raise "has_contract required the model to implement the class method from_contract"
        end
      end
    end

    module FromContract
      def self.register_responder contract_class, responder
        responder.send :include, Responder unless responder < Responder
        responders[contract_class.to_s] = responder
      end

      def self.responder_for contract
        responders[contract.class.to_s]
      end

      def self.responders
        @responders ||= {}
      end

      module Responder
        def self.included base
          base.extend ClassMethods
        end
        module ClassMethods
          def from_contract contract
            raise "from_contract requires the model to implement class methods from_contract"
          end
        end
      end
    end

    module ActiveRecord
      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods
        def has_contract contract_class
          raise "#{contract_class} is not a subclass of Contract" unless contract_class < Contract
          HasContract.register_responder contract_class, self
        end
        def from_contract contract_class
          raise "#{contract_class} is not a subclass of Contract" unless contract_class < Contract
          FromContract.register_responder contract_class, self
        end
      end
    end
  end
end
