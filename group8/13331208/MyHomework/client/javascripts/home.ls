Template['home'].helpers {
  user: -> Meteor.user!
  userIsTeacher: -> if Meteor.user! and 'teacher' in Meteor.user!.roles then true else false
}