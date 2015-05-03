Assignments = new Mongo.Collection 'assignments'
if Meteor.isClient
  Accounts.ui.config {passwordSignupFields: 'USERNAME_ONLY'}

  Template.body.helpers {
    isAdmin: ->
      Meteor.user().username == 'admin'
    isLoged: ->
      Meteor.userId()
  }

  Template.teacher.events {
    "click .assign" : !->
      Session.set 'state' 'assignments'
    "click .homeworks" : !->
      Session.set 'state' 'Homework'
    "click .publish" : !->
      Session.set 'state' 'publish'
  }

  Template.teacher.helpers {
    showAssignments : ->
      (Session.get 'state') == 'assignments'
    showHomework : ->
      (Session.get 'state') == 'Homework'
    showPublish : ->
      (Session.get 'state') == 'publish'
  }

  Template.publish.events {
    'submit .publish': (event) ->
      Assignments.insert (
        date: event.target.date.value
        content: event.target.publish.value 
        )
      Session.set 'state' 'assignments'
      return false
  }

  Template.assignments.helpers {
    ASSIGNMENTS : ->
      Assignments.find {}
  }

  Template.student.helpers {
    showAssignments : ->
      (Session.get 'state') == 'assignments'
    showHomework : ->
      (Session.get 'state') == 'Homework'
    showPublish : ->
      (Session.get 'state') == 'publish'
  }
  Template.student.events {
    "click .assign" : !->
      Session.set 'state' 'assignments'
    "click .homeworks" : !->
      Session.set 'state' 'Homework'
    "click .publish" : !->
      Session.set 'state' 'publish'
  }