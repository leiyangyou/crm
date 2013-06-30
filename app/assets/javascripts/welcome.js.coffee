# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
(($)->
    codeSubmited = (event, code)->
        $.ajax(
            url: "/welcome/" + encodeURIComponent(code)
            type: "POST",
            dataType: "script"
        )
    $(()->
        $('#member-id').member_id_input({
            placeHolder: "刷卡或者输入会员号"
        }).bind("codeSubmited", codeSubmited)
        $('#notification').html('')
        $.extend(window, (()->
            no_accont_found = (id)->
                alert("cannot find #{id}")
            update_account = (account)->
                $('#welcome-info .name').html(account.name);
                if(avatar = account.avatar && account.avatar.url)
                    $('#avatar img').attr("url", avatar)
                $notification = $('#notification').html('')
                if dob = account.dob
                    dob = dob.split("-")
                    today = new Date();
                    if `today.getDate() == dob[2]` && `today.getMonth() + 1 == dob[1]`
                        $notification.append("<li class=\"important\">#{dob[1]}-#{dob[2]} 生日快乐</li>")
                if account["active?"]
                    $notification.append("<li class=\"info\">剩余#{account.remaining}天</li>")
                else if account["transferred?"]
                    $notification.append("<li class=\"important\">账号已转让</li>")
                else if account["suspended?"]
                    $notification.append("<li class=\"important\">账号已暂停</li>")
                else if account["expired?"]
                    $notification.append("<li class=\"important\">账号已过期</li>")
                if (locker_rents = account.locker_rents) && locker_rents.length > 0
                    for locker_rent in locker_rents
                        if locker_rent["overdue?"]
                            $notification.append("<li class=\"important\">衣柜'#{locker_rent.identifier}'已经过期</li>")

            return {
                no_account_found: no_accont_found
                update_account: update_account
            }
        )())
    )

)(jQuery)