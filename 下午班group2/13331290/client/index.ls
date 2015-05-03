Template['body'].helpers {
	isTeacher: -> Meteor.user!.profile.status is 'teacher'
	isStudent: -> Meteor.user!.profile.status is 'student'
}

Template['body'].events {
	'click .sign-out': !-> Meteor.logout!
}
