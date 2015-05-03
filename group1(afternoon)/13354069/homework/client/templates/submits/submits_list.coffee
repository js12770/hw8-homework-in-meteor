Template.submitsList.helpers 
	submits: -> 
		if Meteor.user().profile.identity is 'teacher'
			Submits.find()
		else if Meteor.user().profile.identity is 'student'
			Submits.find student:"#{Meteor.user().profile.firstName} #{Meteor.user().profile.lastName}"
