root = exports ? @

root.assignment = new Mongo.Collection 'assignment'
root.myassignment = new Mongo.Collection 'myassignment'
root.users = new Mongo.Collection 'users'

root.myassignment.allow {
    insert: -> true
    update: -> true
    remove: -> true
}


Meteor.methods {
    'udateassignment': (aid, newDeadline, newtitle)!-> myassignment.update {assignmentid: aid}, { $set : { deadline: newDeadline, title: newtitle} }, {multi: true}
}