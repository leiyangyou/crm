(($)->
  crm.my_date_select_popup = (id, dropdown_id, show_time)->
    button_id = "#{id}-picker"
    element = $("##{id}")
    element.width(204)
    element.css('display': 'inline', 'margin-right': '5px')
    picker = $("##{button_id}")
    unless picker.length > 0
      picker = $('<button>...</button>').attr('id', button_id).insertAfter(element)
    Calendar.setup(
      trigger: button_id
      inputField : id
      show_time : show_time
      onSelect : ()->@hide()
    )
)(jQuery);