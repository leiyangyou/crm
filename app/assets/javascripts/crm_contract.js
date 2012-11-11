(function($){
    crm.create_contract = function(contract_type, input_id, parameters){
        var url, parameters_string;
        if(input_id != null){
            window.contract_callback = function(input_id){
                return function(contract_id){
                    $('#' + input_id).val(contract_id)
                }
            }(input_id);
        }
        url = ["", "contract_types", contract_type, "contracts", "new"].join("/");
        parameters = parameters || {};
        if( input_id != null){
            parameters.callback = "contract_callback";
        }
        parameters_string = (function(){
            var results = [];
            for( key in parameters){
                results.push(key + "=" + parameters[key])
            }
            return results;
        })().join("&");
        if(parameters_string.length > 0){
            url = url + "?" + parameters_string;
        }
        window.open(url, "_blank");
        return false
    }
})(jQuery);