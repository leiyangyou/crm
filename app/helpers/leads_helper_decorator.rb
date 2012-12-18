LeadsHelper.class_eval do

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
end