Template['edit'].helpers {
	assignment: -> Assignments.find-one {_id: Session.get 'assignmentId'}
}

Template['edit'].events {
	'submit .edit-assignment': (e)!->
		e.prevent-default!
		Meteor.call 'edit-assignment' (Session.get 'assignmentId'), e.target.deadline.value, e.target.requirement.value
		$ '.all-assignments' .trigger 'click'
}