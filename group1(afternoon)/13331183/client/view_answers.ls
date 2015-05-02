Template["view_answers"].helpers {
  is-viewing-answer: ->
    flag = Session.get 'viewAnswer'
    if flag
      flag.state == true
    else
      false
  answers: ->
    user = Session.get 'current-user'
    if user.character == "teacher"
        answers = Answers.find {homeworkID : Session.get 'homeworkID'}
    else
        answers = Answers.find {homeworkID : (Session.get 'homeworkID'), master: user.username}
  can-check-score: ->
    user = Session.get 'current-user'
    user.character == "teacher"
}
Template["view_answers"].events {
    "click .check-score": ->
        Session.set 'viewAnswer', {"state" : false}
        Session.set "showHomePage", {"state":true}
    "click .return-home": ->
        Session.set 'viewAnswer', {"state" : false}
        Session.set "showHomePage", {"state":true}
}