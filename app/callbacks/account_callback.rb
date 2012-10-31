class AccountCallback < FatFreeCRM::Callback::Base
  def account_tools_before view, context
    result = ""
    account = context[:account]
    if account.membership
      if account.expired?
        result << view.content_tag(:li) do
          view.link_to_renewal(account)
        end
      end
      if account.normal?
        result << view.content_tag(:li) do
          view.link_to_suspend(account)
        end
        result << view.content_tag(:li) do
          view.link_to_transfer(account)
        end
      end
    else
      result << view.content_tag(:li) do
        view.link_to_renewal(account)
      end
    end
    result
  end

  def account_bottom view, context
    result = ""
    account = context[:account]
    if membership = account.membership
      result << membership.type.name + ":"
      result << "#{membership.start_date.strftime("%Y/%m/%d")} - #{membership.due_date.strftime("%Y/%m/%d")}"
      if membership.expired?
        result << view.content_tag(:span, :class => "warning") do
          view.t(:expired)
        end
      end
    end
    result
  end
end