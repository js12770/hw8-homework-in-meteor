Template['homework_list'].helpers {
  homeworks:->
    Homeworks.find {}
  is-state: (arg)->
    return Session.equals 'currentState', 'homePage'
}

Template['homework_list'].events {
  'click .publishHw': (ev, tpl)!->
    ev.prevent-default!
    ev.stopPropagation!
    Session.set 'currentState', 'createHw'
    Session.set 'editState', 'create'
  'click .hwDetails': (ev, tpl)!->
    ev.prevent-default!
    Session.set 'currentState', 'hwDetails'
    Session.set 'currentHw', this
}