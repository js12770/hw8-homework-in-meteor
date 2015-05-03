Template['modify'].helpers {
  is-modifing:(assignment) ->
    Session.get 'modify'?
    Session.get 'assignmentId'?
    Session.get 'modify' .toString! is 'true' and (Session.get 'assignmentId' .toString!) is assignment._id.toString!
}

Template['modify'].events {
  'submit .modify': (ev)->
    ev.prevent-default!
    console.log this._id

    assignmentId = this._id
    name = ev.target.name.value
    content = ev.target.content.value
    deadline = ev.target.deadline.value
    
    Meteor.call 'modifyAssignment', assignmentId, name, content, deadline

    Session.set 'modify', 'false'

    return false
}