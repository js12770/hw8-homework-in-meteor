root = exports ? @

root.Assignment = new Mongo.Collection 'Assignment'
root.Homework = new Mongo.Collection 'Homework'
root.User = new Mongo.Collection 'User'


Router.route '/', ->

Meteor.startup -> if Meteor.is-client
  $ 'form[data-parsley-validate]' .parsley!