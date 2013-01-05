module ContractsHelper
  def link_to_sign_contract contract
    link_to(t("view.contract.sign"), sign_account_contract_path(contract.account, contract), :method => :post, :remote => true)
  end

  def link_to_edit_contract contract
    link_to(t("view.contract.edit"), edit_account_contract_path(contract.account, contract), :method => :get, :remote => true)
  end
end
