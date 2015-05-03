Template['allhomeworks'].helpers {
  user: -> Meteor.user!
  userIsTeacher: -> if Meteor.user! and 'teacher' in Meteor.user!.roles then true else false
  userIsStudent: -> if Meteor.user! and 'student' in Meteor.user!.roles then true else false
  homeworks: -> Homeworks.find!fetch!
  getStartDate: -> moment(this.startDate).format('YYYY-MM-DD HH:mm')
  getDeadline: -> moment(this.deadline).format('YYYY-MM-DD HH:mm')
}