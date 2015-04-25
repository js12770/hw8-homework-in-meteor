Template['article'].helpers {
	isAuthor: !->
		if Meteor.user()
			if Meteor.user().profile['identity'] is 'T' and this.Assignment.author is Meteor.user().emails[0]['address']
				return true
			else
				return false
}

Template['article'].events {
	'click #changescore': (e)!->
		e.preventDefault!
		currentHomeworkId = this.Homework._id

		HomeworkProperties = {
			score: ($ '#score').val!
		}

		Homeworks.update currentHomeworkId, {$set: HomeworkProperties}, (error) !->
			if error
				alert error.reason
}
