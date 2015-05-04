Template['createHw'].events {
  'click .submit': (ev, tpl)!->
    ev.prevent-default!
    title = ($ 'input[name=title]').val!
    require = ($ 'textarea[name=require]').val!
    deadline =  ($ 'input[name=deadline]').val!
    if deadline == "" 
      alert 'deadline required!'
      return
    if Session.equals 'editState', 'create'
      Homeworks.insert homework = {title, require, deadline}
    else
      Homeworks.update {_id: Session.get 'currentHw' ._id} , {$set:{require:require, deadline:deadline}}
    Session.set 'currentState', 'homePage'

  'click .hw-list': (ev, tpl)!->
    ev.prevent-default!
    Session.set 'currentState', 'homePage'
}

Template['createHw'].helpers {
  is-state: (arg)->
    return Session.equals 'currentState', arg
  homework:->
    return Session.get 'currentHw'
  isEditState: (arg)->
    return Session.equals 'editState', arg
}