Template["hand_in_answer"].helpers {
  is-handing-in-answer: ->
      if Session.get 'handInAnswer'
        flag = Session.get 'handInAnswer'
        flag.state == true
      else
        false
}
Template["hand_in_answer"].events {
    'click button': (ev, tpl) -> 
      ev.prevent-default!
      content = ($ 'textarea[name=answer_content]').val!
      user = Session.get 'current-user'
      master = user.username
      homeworkID = Session.get 'homeworkID'
      homework = Homeworks.findOne {_id : Session.get 'homeworkID'}
      homeworkTitle = homework.title
      score = 0
      if content
        Meteor.call("hand-in-answer", homeworkID, master, homeworkTitle, content, score);
        Session.set 'handInAnswer', {"state" : false}
        Session.set "showHomePage", {"state":true}
      else
        alert 'fill content'
    "click .return-home": ->
        Session.set 'handInAnswer', {"state" : false}
        Session.set "showHomePage", {"state":true}
}