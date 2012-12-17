module AccountDecorator
  module ContractHandler
    def contract_signed contract
      if CRM::Contractable.instance_based? contract
        responder = CRM::Contractable::HasContract.responder_for contract
        instance = responder.from_contract contract
        instance.contract_signed contract if instance
        instance
      elsif CRM::Contractable.class_based? contract
        responder = CRM::Contractable::FromContract.responder_for contract
        instance = responder.from_contract contract
        if instance.save
          contract.save
        end
        instance
      end
    end
  end
end