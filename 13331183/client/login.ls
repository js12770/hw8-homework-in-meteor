Template["login"].helpers {
  isnt-authenticated: ->
    not Session.get 'current-user'
  isnt-signuping: ->
    flag = Session.get 'signup'
    if flag
      flag.state == false
    else
      true
}
Template["login"].events {
    'click button': (ev, tpl) -> 
      ev.prevent-default!
      username = ($ 'input[name=username]').val!
      password = ($ 'input[name=password]').val!
      user = Users.findOne $and: [{username}, {password}]
      if user 
        Session.set 'current-user', user
        Session.set "showHomePage", {"state":true}
      else
        alert  "(s)he's has not already register."
    "click .new-account": ->
         Session.set 'signup', {"state" : true}
}