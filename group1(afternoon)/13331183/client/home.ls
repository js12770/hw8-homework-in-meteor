Template["home"].helpers {
  is-authenticated: ->
    Session.get 'current-user'
  should-show-home-page: ->
    flag = Session.get 'showHomePage'
    if flag
        flag.state == true
    else
        false
  is-teacher: ->
      user = Session.get 'current-user'
      if user
        user.character == "teacher"
      else
        false
  homeworks: -> 
    homeworks = Homeworks.find!
  user: -> 
    user = Session.get 'current-user'
}
Template["home"].events {
    'click .show-homework': (ev, tpl) -> 
        homeworkID = ($ ev.target .attr "name")
        Session.set "homeworkID", homeworkID
        Session.set "showHomework", {"state":true}
        Session.set "showHomePage", {"state":false}
    "click .publish-homework": ->
        Session.set 'publishHomework', {"state" : true}
        Session.set "showHomePage", {"state":false}
    "click .logout": ->
        Session.set 'current-user', {"state" : true}
        Session.set "showHomePage", {"state":false}
}