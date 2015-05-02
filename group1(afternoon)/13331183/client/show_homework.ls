Template["show_homework"].helpers {
  is-showing-homework: ->
    flag = Session.get 'showHomework'
    if flag
      flag.state == true
    else
      false
  homework: ->
    homework = Homeworks.find {_id : Session.get 'homeworkID'}
  is-student: ->
    user = Session.get 'current-user'
    if user
      user.character == "student"
    else
      false
  is-teacher: ->
    user = Session.get 'current-user'
    if user
      user.character == "teacher"
    else
      false
}
Template["show_homework"].events {
    'click .hand-in-answer': (ev, tpl) -> 
      ev.prevent-default!
      Session.set 'showHomework', {"state" : false}
      Session.set "handInAnswer", {"state":true}
    'click .modify-homework': (ev, tpl) -> 
      ev.prevent-default!
      Session.set 'showHomework', {"state" : false}
      Session.set "modifyHomework", {"state":true}
    'click .watch-answer' : ->
        Session.set 'publishHomework', {"isPublishHomework" : true}
    "click .view-answer": ->
        Session.set 'viewAnswer', {"state" : true}
        Session.set "showHomework", {"state":false}
    "click .return-home": ->
        Session.set 'showHomework', {"state" : false}
        Session.set "showHomePage", {"state":true}
}