Template['create'].helpers {
  is-Creating: ->
    Session.get 'create'?
    Session.get 'create' .toString! is 'true'
}

Template['create'].events {
  'submit .create': (ev)->
    ev.prevent-default!
    
    userId = Meteor.users.find-one {_id: Meteor.userId!} ._id
    name = ev.target.name.value
    author = Meteor.users.find-one {_id: Meteor.userId!} .firstName + ' ' + Meteor.users.find-one {_id: Meteor.userId!} .lastName
    content = ev.target.content.value
    deadline = ev.target.deadline.value
    
    console.log userId
    
    Meteor.call 'createAssignment', userId, name, author, content, deadline

    Session.set 'create', 'false'

    return false
}