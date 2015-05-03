Template['setAssignment'].helpers {
	ispublish: -> Session.get('ispublish') is true
	assignment: -> Session.get 'editassi'
}

Template['setAssignment'].events {
	'submit .publish': (e)!->
		e.prevent-default!
		assign =
			author: Session.get('currentuser' ).firstName
			deadline: e.target.deadline.value
			title: e.target.title.value
			content: UE.getEditor 'editor1' .getContent!
		assignment.insert assign
		$ '.setassignment' .add-class 'hidden'
		$ '.assignment' .remove-class 'hidden'

	'submit .edit': (e)!->
		e.prevent-default!
		assign =
			author: Session.get('currentuser' ).firstName
			deadline: e.target.deadline.value
			title: e.target.title.value
			content: UE.getEditor 'editor2' .getContent!
		#myassignment.update {assignmentid: "ENfqk8PCyNxgn5M4L"}, { $set : { deadline: assign.deadline, title: assign.title} }, {multi: true}
		Meteor.call 'udateassignment' (Session.get 'editassi')._id, assign.deadline, assign.title
		assignment.update {_id: (Session.get 'editassi') ._id}, {$set: {deadline: assign.deadline, title: assign.title, content: assign.content}}
		$ '.setassignment' .add-class 'hidden'
		$ '.submitAssignmentList' .remove-class 'hidden'
		$ '.assignment' .remove-class 'hidden'
}

