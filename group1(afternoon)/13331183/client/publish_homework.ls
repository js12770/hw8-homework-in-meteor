Template["publish_homework"].helpers {
   is-publishing-homework: ->
    flag = Session.get 'publishHomework'
    if flag
        flag.state == true
    else
        false
}
Template["publish_homework"].events {
    'click button': (ev, tpl) -> 
      ev.prevent-default!
      title = ($ 'input[name=homework_title]').val!
      deadline = ($ 'input[name=homework_deadline]').val!
      demand = ($ 'textarea[name=homework_demand]').val!
      user = Session.get 'current-user'
      if title and deadline and demand
          master = user.username
          Meteor.call("publish-homework", master, title, deadline, demand);
          Session.set 'publishHomework', {"state" : false}
          Session.set "showHomePage", {"state":true}
      else
          alert 'fill the message'
    "click .return-home": ->
        Session.set 'publishHomework', {"state" : false}
        Session.set "showHomePage", {"state":true}
}