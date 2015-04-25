Template['homeworkDetail'].onRendered !->
	this.$ '#datetimepicker' .datetimepicker {
		format: 'YYYY-MM-DD HH:mm'
	}

Template['homeworkDetail'].helpers {
	isAuthor: !->
		if Meteor.user()
			if Meteor.user().profile['identity'] is 'T' and this.Assignment.author is Meteor.user().emails[0]['address']
				return true
			else
				return false
	isTeacher: !->
		if Meteor.user()
			if Meteor.user().profile['identity'] is 'T'
				return true
			else
				return false
}

Template['homeworkDetail'].events {
	'click #changebrief': (e)!->
		($ '#dochange').attr 'temp', 'brief'
		($ '#message-text').val ($ '#briefIntroduction').text!

	'click #changedetails': (e)!->
		($ '#dochange').attr 'temp', 'details'
		($ '#message-text').val ($ '#details').text!

	'click #changetitle': (e)!->
		($ '#dochange').attr 'temp', 'title'
		($ '#message-text').val ($ '#title').text!

	'click #dochange' : (e)!->
		e.preventDefault!
		currentAssignmentId = this.Assignment._id;
		tar-pro = ($ '#dochange').attr 'temp'

		if tar-pro is 'brief'
			AssignmentProperties = {
				brief: ($ '#message-text').val!
			}
			Assignments.update currentAssignmentId, {$set: AssignmentProperties}, (error) !->
				if error
					alert error.reason
		if tar-pro is 'details'
			AssignmentProperties = {
				details: ($ '#message-text').val!
			}
			Assignments.update currentAssignmentId, {$set: AssignmentProperties}, (error) !->
				if error
					alert error.reason
		if tar-pro is 'title'
			AssignmentProperties = {
				title: ($ '#message-text').val!
			}
			Assignments.update currentAssignmentId, {$set: AssignmentProperties}, (error) !->
				if error
					alert error.reason
	'click #changedeadline' : (e)!->
		currentAssignmentId = this.Assignment._id
		AssignmentProperties = {
			deadline: ($ '#datetimepicker').val!
		}
		Assignments.update currentAssignmentId, {$set: AssignmentProperties}, (error) !->
			if error
				alert error.reason
}
