class AccountCallback < FatFreeCRM::Callback::Base
  def account_tools_before view, context
    result = ""
    account = context[:account]
    if account.membership
      if account.suspended?
        result << view.content_tag(:li) do
          view.link_to_continue(account)
        end
      end
      if account.expired?
        result << view.content_tag(:li) do
          view.link_to_renewal(account)
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
        view.link_to_renewal(account)
      end
    end
    result
  end

  def account_bottom view, context
=begin
    result = ""
    account = context[:account]
    if (membership = account.membership) && membership.type
      result << membership.type.name + ":"
      result << "#{membership.start_date.strftime("%Y/%m/%d")} - #{membership.due_date.strftime("%Y/%m/%d")}"
      if membership.contract_id
        result << "("
        result << view.link_to(view.t(:contract), view.contract_path(membership.contract_id))
        result << ")"
      end
      if membership.expired?
        result << view.content_tag(:span, :class => "warning") do
          view.t(:expired)
        end
      end
      if membership.transferred?
        membership_transfer = membership.membership_transfer
        result << view.content_tag(:span, :class => "warning") do
          if membership_transfer.contract_id
            view.link_to( view.t(:transferred), view.contract_path(membership_transfer.contract_id))
          else
            view.t(:transferred)
          end
        end
      end
      if membership.suspended?
        membership_suspension = membership.membership_suspensions.latest
        result << view.content_tag(:span, :class => "warning") do
          if membership_suspension.contract_id
            view.link_to( view.t(:suspended), view.contract_path(membership_suspension.contract_id))
          else
            view.t(:suspended)
          end
        end
      end
    end
    result
=end
  end
end