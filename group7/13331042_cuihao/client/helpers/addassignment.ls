Template['addAssignment'].onRendered !->
	this.$ '#datetimepicker' .datetimepicker {
		format: 'YYYY-MM-DD HH:mm'
	}

Template['addAssignment'].helpers {
	title: -> this.title,
	deadlie: -> this.deadlie,
	author: -> this.author
}

Template['addAssignment'].events {
	'submit form': (e)!->
		e.preventDefault!

		assignment = {
			title: $ e.target .find '[name=title]' .val!
			brief: $ e.target .find '[name=brief]' .val!
			author: Meteor.user().emails[0]['address']
			details: $ e.target .find '[name=details]' .val!
			deadline: $ e.target .find '[name=deadline]' .val!
		}

		assignment._id = Assignments.insert assignment
		Router.go '/assignmentdetail/'+assignment._id
}
