Template["signup"].helpers {
  isnt-authenticated: ->
    not Session.get 'current-user'
  is-signuping: ->
    flag = Session.get 'signup'
    if flag
      flag.state == true
    else
      false
}
Template["signup"].events {
    'click button': (ev, tpl) -> 
      ev.prevent-default!
      username = ($ 'input[name=username]').val!
      password = ($ 'input[name=password]').val!
      email = ($ 'input[name=email]').val!
      first-name = ($ 'input[name=firstName]').val!
      last-name = ($ 'input[name=lastName]').val!
      character = ($ 'input[name=character]:checked').val!
      user = Users.findOne $and: [{email}, {username}]
      if user then alert "Can't register user: #{username}, #{email} anymore, cause (s)he's already register." else
        Users.insert user = {username, password, email, first-name, last-name, character}
        Session.set 'current-user', user
        Session.set "showHomePage", {"state":true}
    "click .return-home": ->
        Session.set 'signup', {"state" : false}
}