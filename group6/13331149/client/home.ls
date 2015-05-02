Template.home.helpers {
  username: -> Meteor.user!.username
  email: -> Meteor.user!.profile.email
  firstName: -> Meteor.user!.profile.firstName
  lastName: -> Meteor.user!.profile.lastName
  role: -> Meteor.user!.profile.role
}

Template.home.events {
  'click .logout': (event)->
      event.preventDefault!
      Meteor.logout!
}