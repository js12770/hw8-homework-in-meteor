Template['home'].helpers {
	firstName: -> 
		if Meteor.user!
			Meteor.user().profile['first-name']
	lastName: -> 
		if Meteor.user!
			Meteor.user().profile['last-name']
	email: -> 
		if Meteor.user!
			Meteor.user().emails[0]['address']
	isStudent: !->
		if Meteor.user!
			if Meteor.user().profile['identity'] is 'S'
				return true
			else
				return false
}
