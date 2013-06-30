class AccountCallback < FatFreeCRM::Callback::Base
  def account_tools_before view, context
    result = ""
    account = context[:account]
    if account.membership
      if account.suspended?
        result << view.content_tag(:li) do
          view.link_to_resume(account)
        end
      end
      if account.expired?
        result << view.content_tag(:li) do
          view.link_to_renew(account)
        end
      end
      if account.active?
        result << view.content_tag(:li) do
          view.link_to_suspend(account)
        end
        result << view.content_tag(:li) do
          view.link_to_transfer(account)
        end
      end
    else
      result << view.content_tag(:li) do
        view.link_to_renew(account)
      end
    end
    result
  end

  def account_bottom view, context

  end
end