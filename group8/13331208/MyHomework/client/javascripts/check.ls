Template['check'].helpers {
  user: -> Meteor.user!
  userIsTeacher: -> if Meteor.user! and 'teacher' in Meteor.user!.roles then true else false
  userIsStudent: -> if Meteor.user! and 'student' in Meteor.user!.roles then true else false
  getUploadDate: -> moment(this.uploadDate).format('YYYY-MM-DD HH:mm')
}