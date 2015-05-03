Meteor.publish 'homeworks', -> 
	Homeworks.find {}, sort: ddl: -1

Meteor.publish 'submits', -> 
	Submits.find {}, sort: ddl: -1