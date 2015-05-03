Template['login'].helpers {
  is-login: ->
    Session.get 'status'?
    Session.get 'status' .toString! is 'isLogin'
}

Template['login'].events {
  'click .new-account': ->
    Session.set 'status', 'isSignup'
}