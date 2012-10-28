module LockersHelper
  def link_to_rent locker, params={}
    link_to( t(:rent), ['new_rent', locker],
      :method => :get,
      :remote =>true,
      :with => "{ previous: crm.find_form('new_rent_locker') }"
    )
  end

  def link_to_restore model, params={}
  end
end
