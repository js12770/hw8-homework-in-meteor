Template['info'].helpers {
  user: ->
    user-original = Meteor.user!
    user-view = {}
    user-view.username = user-original.username
    user-view.email = user-original.emails[0].address
    user-view.firstName = user-original.profile.firstName
    user-view.lastName = user-original.profile.lastName
    user-view
}