root = exports ? @

root.Homeworks = new Mongo.Collection 'Homeworks'
root.Answers = new Mongo.Collection 'Answers'

Meteor.methods {
  'remove-all-homeworks': -> Homeworks.remove {} 
  'add-fake-homework': -> for i in [1 to 108]
    Homeworks.insert Hw_id: i,  title: i, require: i, deadline: i
}

Meteor.startup -> if Meteor.is-client
  Session.set 'currentState', 'homePage'
  Accounts .ui .config passwordSignupFields: 'USERNAME_ONLY'