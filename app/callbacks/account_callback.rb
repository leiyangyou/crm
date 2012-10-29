class AccountCallback < FatFreeCRM::Callback::Base
  def account_tools_before view, context
    account = context[:account]
    if account.membership
      if account.expired?
        view.content_tag(:li) do
          view.link_to_renewal(account)
        end
      end
      if account.normal?
        view.content_tag(:li) do
          view.link_to_suspend(account)
          view.link_to_transfer(account)
        end
      end
    else
      view.content_tag(:li) do
        view.link_to_renewal(account)
      end
    end
  end
end