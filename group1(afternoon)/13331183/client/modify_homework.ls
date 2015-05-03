Template["modify_homework"].helpers {
   is-publishing-homework: ->
    flag = Session.get 'modifyHomework'
    if flag
      flag.state == true
    else
      false
   homework: ->
    homework = Homeworks.find {_id : Session.get 'homeworkID'}
}
Template["modify_homework"].events {
    'click button': (ev, tpl) -> 
      ev.prevent-default!
      homeworkID = Session.get 'homeworkID'
      deadline = ($ 'input[name=homework_deadline]').val!
      demand = ($ 'textarea[name=homework_demand]').val!
      if deadline and demand
          Meteor.call("modify-homework", homeworkID, deadline, demand);
          Session.set 'modifyHomework', {"state" : false}
          Session.set "showHomePage", {"state":true}
      else
          alert 'fill the message'
    'click .return-home' : ->
      Session.set 'modifyHomework', {"state" : false}
      Session.set 'showHomePage', {"state" : true}
}