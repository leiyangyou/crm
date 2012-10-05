module ContractTemplatesHelper
  def link_to_preview( template, params = {})
    link_to(t(:preview), params[])
  end
end
