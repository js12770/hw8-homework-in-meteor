Template['assign'].events {
  'click .button.clear': (ev, tpl)!->
     $ 'input' .val ''
     $ 'textarea' .val ''
  'submit form': (ev, tpl)-> 
    ev.prevent-default!
    title = ($ 'input[name=title]').val!
    date = new Date(($ 'input[name=ddl]').val!)
    ddl = format date
    require = ($ 'textarea[name=require]').val!
    Homework.insert homework = {title, ddl, date, require}
}
Template['assign'].helpers {
  is-teacher: ->
    Meteor.user! and Meteor.user! .username is "teacher"
}

format = (date)->
  time = date.getTime! - 28800000
  date.setTime time
  year = addzore date.get-full-year!
  month = addzore (date.get-month! + 1)
  day = addzore date.get-date!
  hour = addzore date.get-hours!
  minute = addzore date.get-minutes!
  year+'/'+month+'/'+day+' '+hour+':'+minute

addzore = (s) ->
  str = s.toString!
  if str.length < 2
    str = '0' + str
  str