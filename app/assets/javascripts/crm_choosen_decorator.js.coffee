# Initialize chosen select lists for certain fields
crm.init_chosen_fields = ->
  ['assigned_to', '[country]', 'trainer_id', 'rating', 'source', 'gender', 'status', 'contracts_membership_contract[type_id]', 'contracts_membership_transfer_contract[target_id]'].each (field) ->
    $$("select[name*='"+field+"']").each (el) ->
      new Chosen el, { allow_single_deselect: true }
