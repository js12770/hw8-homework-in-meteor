Template['homework_list'].helpers {
    homeworks1: ->
      homeworks1 = []
      homeworks = Homework.find!fetch!
      for homework in homeworks
        if (Date.parse homework.date) > (Date.parse Date!)
          homeworks1.push homework
      homeworks1

    homeworks2: ->
      homeworks2 = []
      homeworks = Homework.find!fetch!
      for homework in homeworks
        if (Date.parse homework.date) < (Date.parse Date!)
          homeworks2.push homework
      homeworks2

    studenthomeworks: ->
      studenthomeworks = Studenthomework.find {hwid:Session.get 'current-hwid'}
      studenthomeworks

    is-teacher: ->
      Meteor.user! and Meteor.user! .username is "teacher"
}

Template['homework_list'].events {
  'click .delete':  !-> 
    Homework.remove {_id : this._id}

  'click .check':(event, template)  !->
    Session.set 'current-hwid', this._id
    $ event.target .parent! .parent! .next!  .slideToggle!

  'click .showmodify':(event, template)  !->
    $ event.target .parent! .parent! .next! .next! .slideToggle!

  'click .modifytitle': (ev, tpl)-> 
    ev.prevent-default!
    Homework.update {_id : this._id}, {$set:{title: ($ event.target .parent! .parent! .find 'input[name=title]').val!}}

  'click .modifyrequire': (ev, tpl)-> 
    ev.prevent-default!
    Homework.update {_id : this._id}, {$set:{require: ($ event.target .parent! .parent! .find 'textarea[name=require]').val!}}

  'submit form': (ev, tpl)-> 
    ev.prevent-default!
    ddlstring = ($ event.target .parent! .parent! .find 'input[name=ddl]').val!
    date = new Date ddlstring
    ddl = format date
    Homework.update {_id : this._id}, {$set:{ddl: ddl, date:date}}

  'click .give': (ev, tpl)-> 
    ev.prevent-default!
    Studenthomework.update {_id : this._id}, {$set:{score: ($ event.target .parent! .parent! .find 'input[name=score]').val!}}

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