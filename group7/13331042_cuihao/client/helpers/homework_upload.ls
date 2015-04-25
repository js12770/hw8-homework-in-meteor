Template['homeworkUpload'].events {
	'submit form': (e)!->
		e.preventDefault!

		if Homeworks.find {author: Meteor.user().emails[0].address, targetAssignment: this._id} .count! is 0
			homework = {
				title: $ e.target .find '[name=title]' .val!
				author: Meteor.user().emails[0]['address']
				details: $ e.target .find '[name=details]' .val!
				score: '/'
				targetAssignment: this._id
			}
			homework._id = Homeworks.insert homework
			Router.go '/article/'+homework._id
		else
			homework = {
				title: $ e.target .find '[name=title]' .val!
				details: $ e.target .find '[name=details]' .val!
			}
			nowHome = Homeworks.find-one {author: Meteor.user().emails[0].address, targetAssignment: this._id}
			nowId = nowHome._id
			console.log nowId
			Homeworks.update nowId, {$set: homework}, (error) !->
				if error
					alert error.reason
			Router.go '/article/'+nowId
}
