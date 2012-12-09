module AppointmentsHelper

  def link_to_cancel_appointment appointment, params={}
    options = {
        :method => :post,
        :remote => true,
    }.merge(params)
    link_to( t(:cancel), cancel_appointment_path(appointment), options)
  end

  def link_to_delete_appointment appointment, params={}
    options = {
        :method => :delete,
        :remote => true
    }
    link_to( t(:delete), appointment_path(appointment), options)
  end
end
