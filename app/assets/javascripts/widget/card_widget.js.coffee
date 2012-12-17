(($)->
  class CardReaderTrigger
    constructor: (target)->
      @$target = $(target)
      @$icon = $('<a class="card-reader-icon">****</a>')
      @$icon.click(@iconClicked)
      @$target.after(@$icon.hide())
      @shown = false
    iconClicked: (event) =>
      @$target.trigger('card_reader.icon_clicked', @$target)
    hide: ()=>
      @$icon.hide()
      @shown = false
    show: ()=>
      if !@shown
        @$icon.show()
        @shown = true
        setTimeout( @hide, 3000)

  class CardReaderDialog
    constructor: ()->
      @$dialog = $('#card-reader-dialog').dialog(
        autoOpen: false
      )
      @$dialog.on( "dialogclose",  @closed)
    ok: ()=>
      @getCurrentTarget() && @getCurrentTarget().trigger("card_reader.dialog_ok")
      @$dialog.dialog('close')
    closed: ()=>
      @getCurrentTarget() && @getCurrentTarget().trigger('card_reader.dialog_closed')
    show: ()->
      @clear()
      @$dialog.dialog('open')
    clear: ()->
      $input = @$dialog.find('#card-reader-input')
      $input.text('')
    append: (char)->
      $input = @$dialog.find('#card-reader-input')
      $input.text($input.text() + char)
    setCurrentTarget: ($target) ->
      @$currentTarget = $target
    getCurrentTarget: ()->
      @$currentTarget
    getValue: ()->
      $input = @$dialog.find('#card-reader-input')
      $input.text()

  CardReaderDialog.createDialog = ()->
    $("""
      <div id="card-reader-dialog" title="Card Reader">
          <div width="100px" id="card-reader-input" />
      </div>""").appendTo('body').hide()

  class CardReader
    constructor: (target)->
      @$target = $(target)
      @initializeTarget()
    initializeTarget: ()->
      @trigger = new CardReaderTrigger @$target
      @$target.hover(@mouseIn)
      @$target.bind('card_reader.icon_clicked', @start)
      @$target.bind('card_reader.dialog_closed', @dialogClosed)
      @$target.bind('card_reader.dialog_ok', @dialogOK)
    dialogOK: ()=>
      @stopReceivingInput()
      @$target.val(CardReaderDialog.instance.getValue())
    dialogClosed: ()=>
      @stopReceivingInput()
    start: (event)=>
      CardReaderDialog.instance.setCurrentTarget(@$target)
      CardReaderDialog.instance.show()
      @startToReceiveInput()
    startToReceiveInput: ()->
      $('body').keydown(@keydown)
    stopReceivingInput: ()->
      $('body').unbind('keydown', @keydown)
    keydown: (event)=>
      which = event.which
      if which == 8 || which == 27 #backspace/or esc
        CardReaderDialog.clear()
      else if which == 13 #enter
        CardReaderDialog.instance.ok()
      else if CardReader.isValidInput(which)
        CardReaderDialog.instance.append(String.fromCharCode(which))
      event.preventDefault()
    mouseIn: (event)=>
      @trigger.show()

  CardReader.isValidInput = (input)->
    (input>= 65 && input<= 90 ) || (input >= 97 && input <= 122)
  $(()->
    CardReaderDialog.createDialog()
    CardReaderDialog.instance = new CardReaderDialog
  )
  window.CardReader = CardReader
)(jQuery)