root = exports ? @

root.Homework = new Mongo.Collection 'Homework'
root.Studenthomework = new Mongo.Collection 'Studenthomework'

Router.route '/', ->

if Meteor.is-client
	Accounts.ui.config {passwordSignupFields:"USERNAME_ONLY"}

if Meteor.is-server
	Meteor.startup -> 
		user = {username: 'teacher', password: 'teacher'}
		if ! Meteor.users.find-one {username:'teacher'}
			Accounts.create-user user