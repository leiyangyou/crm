module LockersHelper
  def link_to_rent locker, params={}
    options = {
      :method => :get,
      :remote =>true,
      :with => "{ previous: crm.find_form('new_rent_locker') }"
    }.merge(params)
    link_to( t(:rent), ['new_rent', locker], options)
  end

  def link_to_restore locker, params={}
    options = {
        :method => :post,
        :remote => true
    }
    options = options.merge(
        :confirm => "Isn't overdue, Are u sure?'"
    ) unless locker.overdue?
    link_to( t(:restore), ['restore', locker], options.merge(params))
  end
end
