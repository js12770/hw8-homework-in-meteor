Template.nav_bar_left.helpers {
	role: -> Meteor.user!.profile.role

	is-teacher: -> Meteor.user!.profile.role == 'teacher' ? true : false
}