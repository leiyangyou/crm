(function($){
    crm.create_contract = function(contract_type, input_id){
        if(input_id != null){
            window.contract_callback = function(input_id){
                return function(contract_id){
                    $('#' + input_id).val(contract_id)
                }
            }(input_id);
        }
        url = ["", "contract_types", contract_type, "contracts", "new"].join("/");
        if( input_id != null){
            url = url +"?callback=contract_callback"
        }
        window.open(url, "_blank");
        return false
    }
})(jQuery);