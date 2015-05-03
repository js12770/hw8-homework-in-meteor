Template['assignment'].helpers {
  is-Student: ->
    Meteor.users.find-one {_id: Meteor.userId!} .status is 'Student'
  
  is-Teacher: ->
    Meteor.users.find-one {_id: Meteor.userId!} .status is 'Teacher'

  assignments: ->
    assignments = assignment.find!fetch!
    return assignments

  homeworks:(assignment)->
    homeworks = homework.find {assignmentId : assignment._id} .fetch!
    return homeworks

  is-current:(assignment) ->
    Meteor.userId! .toString! is assignment.userId

}

Template['assignment'].events {
  'submit .detail': (ev)->
    ev.prevent-default!
    firstName = ev.target.firstName.value
    lastName = ev.target.lastName.value
    status = ev.target.status.value
    Meteor.users.update {_id: Meteor.userId!}, $set: firstName: firstName
    Meteor.users.update {_id: Meteor.userId!}, $set: lastName: lastName
    Meteor.users.update {_id: Meteor.userId!}, $set: status: status
    return false
  'click .c': (ev)->
    console.log 'abc'
    Session.set 'create', 'true'
  'click .s': (ev)->
    Session.set 'assignmentId', this._id
    Session.set 'submit', 'true'
  'click .m': (ev)->
    Session.set 'assignmentId', this._id
    Session.set 'modify', 'true'
}