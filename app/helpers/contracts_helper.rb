module ContractsHelper
  def link_to_sign_contract contract
    link_to(t("view.contract.sign"), sign_contract_path(contract), :method => :post, :remote => true)
  end

  def link_to_edit_contract contract
    link_to(t("view.contract.edit"), contract_path(contract), :method => :put, :remote => true)
  end
end
