Template['submit'].helpers {
  is-submitting:(assignment) ->
    Session.get 'submit'?
    Session.get 'assignmentId'?
    Session.get 'submit' .toString! is 'true' and (Session.get 'assignmentId' .toString!) is assignment._id.toString!
}

Template['submit'].events {
  'submit .submit': (ev)->
    ev.prevent-default!

    assignmentId = this._id
    studentName = Meteor.users.find-one {_id: Meteor.userId!} .firstName + ' ' + Meteor.users.find-one {_id: Meteor.userId!} .lastName
    content = ev.target.content.value
    
    
    Meteor.call 'createHomework', assignmentId, studentName, content

    Session.set 'submit', 'false'

    return false
}