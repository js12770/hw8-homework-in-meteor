root = exports ? @

root.Assignments = new Mongo.Collection 'assignments'
submissionStore = new FS.Store.FileSystem 'submissions'
root.Submissions = new FS.Collection 'submissions', {
	stores: [submissionStore]
}

root.Submissions.allow {
	insert: -> true
	update: -> true
	remove: -> true
	download: -> true
}

if Meteor.is-client
	Meteor.subscribe 'assignments'
	Meteor.subscribe 'submissions'


if Meteor.is-server
	Meteor.publish 'assignments', -> Assignments.find!
	Meteor.publish 'submissions', -> Submissions.find!


Meteor.methods {
	'create-user': (option)!-> Accounts.createUser option
	'publish-assignment': (assignment)!-> Assignments.insert assignment
	'delete-assignment': (id)!-> Assignments.remove {_id: id}
	'edit-assignment': (id, newDeadline, newRequirement)!-> Assignments.update {_id: id}, {$set: {deadline: newDeadline, requirement: newRequirement}}
	'submit-assignment': (id, filePath)!->
		for submission, index in (Assignments.find-one {_id: id}).submission
			if submission.id == Meteor.userId!
				Assignments.update {'_id': id}, {$set: {('submission.' + index + '.filePath'): filePath}}
				return

		Assignments.update {_id: id}, {$push: {submission: {'id' : Meteor.userId!, 'studentId': Meteor.user!.profile.id, 'name' : Meteor.user!.username, 'filePath': filePath, 'score': ''}}}

	'revise-assignment': (scores, id)!->
		for score, index in scores
			Assignments.update {_id: id}, {$set: {('submission.' + index + '.score'): score}}
}