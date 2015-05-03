Template.signin.events {
  'submit form': (e)->
    e.preventDefault!

    username = ($ e.target) .find '[name=username]' .val!
    password = ($ e.target) .find '[name=password]' .val!

    Meteor.login-with-password username, password, (error) ->
      if error
        alert error.reason
      else
        Router.go 'index'
}