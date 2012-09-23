# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

MS_IN_A_DAY = 60 * 60 * 24 * 1000
document.observe("dom:loaded", ()->
  calendar = Calendar.setup({
    cont: 'week-picker'
    weekNumbers: true
    fdow: 0
    onSelect: (()->
      day = Calendar.intToDate(this.selection.getFirstDate())
      beginning_of_the_week_as_date = new Date(+day - MS_IN_A_DAY * day.getDay())
      end_of_the_week_as_date = new Date(+beginning_of_the_week_as_date + 6 * MS_IN_A_DAY)
      beginning_of_the_week = Calendar.dateToInt(beginning_of_the_week_as_date)
      end_of_the_week = Calendar.dateToInt(end_of_the_week_as_date)
      if (this.selection.getFirstDate() != beginning_of_the_week ||
          this.selection.getLastDate() != end_of_the_week )
        this.selection.reset([[beginning_of_the_week, end_of_the_week]])
    )
  })
  calendar.selection.reset(Calendar.dateToInt(new Date))
)
