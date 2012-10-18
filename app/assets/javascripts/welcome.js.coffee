# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
(($)->
  $(()->
    member_id = {
      block: $('member-id')
      clear: ()->
        this.block.text()
      append: (char)->
        this.block.text(this.text() + char)
      text: ()->
        this.block.text()
    }
    is_alphanum: (input)->
      (input >= 48 && input <= 57 ) || (input >= 65 && input <= 90)
    append_member_id = ()->
    $('body').keypress((event)->
      which = event.which
      if whick == 8 #backspace
        member_id.clear()
      else if which == 13 #enter
        submit_code(member_id.text())
      else if is_laphanum(which)
        member_id.append(String.fromCharCode(which))
    )
  )
)(jQuery)