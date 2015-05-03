root = exports ? @

root.Users = new Mongo.Collection 'Users'
root.Issues = new Mongo.Collection 'Issues'
root.Submits = new Mongo.Collection 'Submits'

Meteor.startup ->
	