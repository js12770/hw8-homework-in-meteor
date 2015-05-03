Template.assignment-page.helpers {
  user: -> Meteor.user!
  is-teacher: ->
    Meteor.user!.profile.identity is 'Teacher'
  is-student: ->
    Meteor.user!.profile.identity is 'Student'
}
