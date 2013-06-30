# Initialize chosen select lists for certain fields
crm.init_chosen_fields = ->
  $$("select:not([choosen])").each (e)->
    $(e).writeAttribute('choosen', true)
    new Chosen e, { allow_single_deselect: true }
