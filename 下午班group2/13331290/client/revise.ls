Template['revise'].helpers {
	assignment: -> Assignments.find-one {_id: Session.get 'assignmentId'}
}

Template['revise'].events {
	'submit form': (e)!->
		e.prevent-default!
		scores = []
		if e.target.score.length >= 2
			for item in e.target.score
				scores.push item.value
		else
			scores.push e.target.score.value

		Meteor.call 'revise-assignment', scores, Session.get 'assignmentId'
		$ '.all-assignments' .trigger 'click'
}