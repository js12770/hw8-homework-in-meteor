Template['homeworkList'].helpers {
	email: ->
		if Meteor.user() 
			Meteor.user().emails[0]['address']
	isTeacher: !->
		if Meteor.user() 
			if Meteor.user().profile['identity'] is 'S'
				return false
			else
				return true
	assignments: !->
		if Assignments.find!.count! is 0
			return null
		else
			return Assignments.find!
}
