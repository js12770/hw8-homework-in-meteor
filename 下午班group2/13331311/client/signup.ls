Template['signup'].helpers {
  is-signup: ->
    Session.get 'status' .toString! is 'isSignup'
}

Template['signup'].events {
  'click .btn' : (ev, tpl)->

    ev.prevent-default!

    username = ($ 'input[name=username]').val!

    ($ 'input[name=username]').val ''

    console.log username
}
