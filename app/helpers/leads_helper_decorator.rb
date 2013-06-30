LeadsHelper.class_eval do
  def consultants
    @consultants ||= User.active.consultants.ranked("consultant")
  end

  def assignable_consultants
    @assignable_consultants ||= if can?(:assign_any_consultant, @lead)
      consultants
    elsif can?(:assign_self_as_a_consultant, @lead)
      [@current_user]
    else
      []
    end
  end

  def lead_status_checbox(status, count)
    checked = (session[:leads_filter] ? session[:leads_filter].split(",").include?(status.to_s) : count.to_i > 0)
    onclick = remote_function(
      :url      => { :action => :filter},
      :with     => h(%Q/"status=" + $$("input[name='status[]']").findAll(function (el) { return el.checked }).pluck("value")/),
      :loading  => "$('loading').show()",
      :complete => "$('loading').hide()"
    )
    check_box_tag("status[]", status, checked, :id => status, :onclick => onclick)
  end

  def link_to_convert(lead)
    link_to(t(:convert), convert_lead_path(lead),
            :method => :get,
            :onclick => "this.href = this.href.split('?')[0] + '?previous='+crm.find_form('edit_lead');",
            :remote => true
    )
  end
end