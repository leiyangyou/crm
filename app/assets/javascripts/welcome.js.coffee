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

      $membership_block =  $('#membership-block')
      last_visit_time = account.last_visit_time
      days_since_last_visit = 0
      if last_visit_time
        m = moment(account.last_visit_time)
        last_visit_time = m.format("YYYY/MM/DD")
        days_since_last_visit = moment.duration(moment().milliseconds() - m.milliseconds()).days()
      else
        last_visit_time = "&nbsp;"
      $membership_block.find('.last_visit_time').html(last_visit_time)
      $membership_block.find('.days_since_last_visit').html(days_since_last_visit)

      console.log(account)
    update_membership = (membership)->
      console.log(membership)
      $membership_block =  $('#membership-block')
      $membership_block.slideUp()
      $membership_block.attr('class', membership.status || "&nbps;")
      $membership_block.find('.membership_status').html(membership.status || "&nbsp;")
      $membership_block.find('.membership_duration').html(membership.duration || "&nbsp;")
      $membership_block.find('.membership_consultant').html((membership.consultant && membership.consultant.name) || "&nbsp;")
      finished_on = "&nbsp;"
      days_before_due_date = 0
      if membership.type
        if membership.finished_on
          m = moment(membership.finished_on)
          finished_on = m.format("YYYY/MM/DD")
          days_before_due_date = moment.duration(moment().milliseconds() - m.milliseconds).days()
      $membership_block.find('.membership_type').html(membership.type || '&nbsp;')
      $membership_block.find('.membership_finished_on').html(finished_on)
      $membership_block.find('.days_before_due_date').html(days_before_due_date)
      $membership_block.slideDown()
    LESSON_TEMPLATE =
      """
      <div class="lesson-block">
        <div class="info">
          <dl>
            <dt>Trainer</dt>
            <dd class="trainer_name"></dd>
            <dt>Lesson Type</dt>
            <dd class="lesson_type"></dd>
            <dt>Used Times</dt>
            <dd class="lesson_used_times"></dd>
            <dt>Surplus Times</dt>
            <dd class="lesson_surplus_times"></dd>
          </dl>
        </div>
      </div>
      """
    update_lessons = (participations) ->
      $right = $('#right')
      $right.html('')
      if participations && participations.size() > 0
        participations.forEach((participation)->
          $lesson_block = $(LESSON_TEMPLATE).hide().appendTo($right)
          if participation.trainer
            $lesson_block.find('.trainer_name').html(participation.trainer.username)
          $lesson_block.find('.lesson_type').html(participation.lesson.name)
          $lesson_block.find('.lesson_used_times').html(participation.lesson.times - participation.times)
          $lesson_block.find('.lesson_surplus_times').html(participation.times || "0")
          $lesson_block.slideDown()
        )
    $.extend(exporter, {
      no_account_found_for: no_account_found_for
      update_account: update_account
      update_membership: update_membership
      update_lessons: update_lessons
    })
  )(window)
)(jQuery)