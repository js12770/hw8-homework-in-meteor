root = exports ? @

root.Homework = new Mongo.Collection 'Homework'
root.Studenthomework = new Mongo.Collection 'Studenthomework'


Router.route '/', ->

Meteor.startup -> if Meteor.is-client
  $ 'form[data-parsley-validate]' .parsley!