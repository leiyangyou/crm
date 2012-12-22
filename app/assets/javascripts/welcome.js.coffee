# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
(($)->
  $(()->
    class MemberIdInput
      constructor: ()->
        @$block = $('#member-id')
        @clear()
      clear: ()->
        @$block.text(MemberIdInput.PLACEHOLDER)
        @$block.addClass('empty')
      append: (char)->
        if @$block.hasClass('empty')
          @$block.text('')
          @$block.removeClass('empty')
        @$block.text( @$block.text() + char)
      text: ()->
        @$block.text()
    MemberIdInput.PLACEHOLDER = "刷卡或者输入会员号码"

    member_id_input = new MemberIdInput()

    is_alphanum = (input)->
      (input >= 48 && input <= 57) || (input >= 65 && input <= 90 ) || (input >= 97 && input <= 122)
    submit_code = (member_id)->
      $.ajax("/welcome/#{member_id}",
        type: "POST"
        dateType: "script"
      )
    $('body').keydown((event)->
      which = event.which
      if which == 8 || which == 27 #backspace/or esc
        member_id_input.clear()
      else if which == 13 #enter
        submit_code(member_id_input.text())
        member_id_input.clear()
      else if is_alphanum(which)
        member_id_input.append(String.fromCharCode(which))
      event.preventDefault()
    )
  )
  ((exporter)->
    no_account_found_for = (account_id)->
      alert("cannot find account for '#{account_id}'")
    update_account = (account)->
      $user_info_block = $('#user-info-block')
      $user_info_block.find('.name').html(account.name || "&nbsp;")
      $user_info_block.find('.phone').html(account.phone || "&nbsp;")
      $user_info_block.find('.gender').html(account.gender || "&nbsp;")
      $user_info_block.find('.phone').html(account.phone || "&nbsp;")
      console.log(account)
    update_membership = (membership)->
      console.log(membership)
      $membership_block =  $('#membership-block')
      $membership_block.attr('class', membership.status)
      $membership_block.find('.membership_status').html(membership.status)
      $membership_block.find('.membership_duration').html(membership.duration)
      $membership_block.find('.membership_consultant').html((membership.consultant && membership.consultant.name) || "&nbsp;")
      if membership.type
        $membership_block.find('.membership_finished_on', membership.finished_on)
      else
        $membership_block.find('.membership_type').html('&nbsp;')
    update_lessons = (participations) ->
      console.log(participations)
      $lesson_block = $('#lesson-block')
      $lesson_block.slideUp()
      if participations && participations.size() > 0
        participation = participations[0]
        if participation.trainer
          $lesson_block.find('.trainer_name').html(participation.trainer.username)
        $lesson_block.find('.lesson_type').html(participation.lesson.name)
        $lesson_block.find('.userd_times').html(participation.lesson.times - participations.times)
        $lesson_block.find('.surplus_times').html(participation.times)
        $lesson_block.slideDown()
    $.extend(exporter, {
      no_account_found_for: no_account_found_for
      update_account: update_account
      update_membership: update_membership
      update_lessons: update_lessons
    })
  )(window)
)(jQuery)