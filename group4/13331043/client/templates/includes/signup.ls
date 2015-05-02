Template.signup.events {
  'submit form': (e)->
    e.preventDefault!

    username = ($ e.target) .find '[name=username]' .val!
    password = ($ e.target) .find '[name=password]' .val!
    name = ($ e.target) .find '[name=name]' .val!
    email = ($ e.target) .find '[name=email]' .val!
    for each-identity in ($ e.target) .find '[name=identity]'
      if each-identity.checked
        identity = each-identity.value

    profile = {
      name: name
      identity: identity
    }

    options = {
      username: username
      password: password
      email: email
      profile: profile
    }

    Accounts.create-user options, (error) ->
      if error
        alert error.reason
      else
        Router.go 'index'
}