(($)->
    handler = (()->
        binded = false
        code = ""
        initialized = false
        isValidKey = (key) ->
            if $.isFunction(options.validKey)
                return options.validKey(key);
            else if $.isArray(options.validKey)
                return $.inArray(key, options.validKey)
            else
                return true
        keyPressed = (event)->
            which = event.which
            if which == 8 || which == 27 #backspace/or esc
                $.each(instances, (index, instance)->
                    instance.trigger("codeRemoved")
                )
                code = ""
            else if which == 13 #enter
                $.each(instances, (index, instance)->
                    instance.trigger("codeSubmited", code)
                    instance.trigger("codeRemoved")
                )
                code = ""
            else if isValidKey(which)
                newCode = String.fromCharCode(which)
                code += newCode
                $.each(instances, (index, instance)->
                    instance.trigger("codeChanged", newCode);
                )
            event.preventDefault()
        bindKeyHandler = ()->
            unless binded
                $('body').keydown($.proxy(keyPressed, this))
                binded = true
        options = {
            validKey: (input)->
                (input >= 48 && input <= 57) || (input >= 65 && input <= 90 ) || (input >= 97 && input <= 122)
            placeHolder: ""
        }
        instances = []
        init = (ops)->
            unless initialized
                $.extend(options, ops);
                bindKeyHandler()
                initialized = true
        addInstance = (instance)->
            $instance = $(instance)
            instances.push($instance)

            $instance.text(options.placeHolder)
            $instance.data("empty", true)

            $instance.bind("codeRemoved", ()->
                $instance.text(options.placeHolder)
                $instance.data("empty", true)
            )
            $instance.bind("codeChanged", (event, newCode)->
                if $instance.data("empty")
                    $instance.text('')
                    $instance.data("empty", false)
                $instance.text($instance.text() + newCode)
            )
        return{
            init: init
            addInstance: addInstance
        }
    )()
    $.fn.member_id_input = ()->
        options = $.extend({}, arguments[0])
        $(this).each(()->
            $this = $(this)
            handler.init(options)
            handler.addInstance($this)
        )
)(jQuery)