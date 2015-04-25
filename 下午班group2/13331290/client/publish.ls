Template['publish'].events {
	'submit .publish-assignment': (e)!->
		e.prevent-default!
		assignment = 
			title: e.target.title.value
			teacherName: Meteor.user!.username
			teacherId: Meteor.userId!
			deadline: e.target.deadline.value
			requirement: e.target.requirement.value
			submission: []
		Meteor.call 'publish-assignment', assignment
		$ '.all-assignments' .trigger 'click'
}