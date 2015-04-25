root = exports ? @

root.assignment = new Mongo.Collection 'assignment'
root.homework = new Mongo.Collection 'homework'

Meteor.methods {
  createAssignment: (userId, name, author, content, deadline) ->
    assignment.insert {
      userId: userId,
      name: name,
      author: author,
      content: content,
      deadline: deadline
    }
  modifyAssignment: (assignmentId, name, content, deadline) ->
    assignment.update { _id: assignmentId}, $set: name: name
    assignment.update { _id: assignmentId}, $set: content: content
    assignment.update { _id: assignmentId}, $set: deadline: deadline
  createHomework: (assignmentId, studentName, content) ->
    if homework.findOne { assignmentId: assignmentId, studentName: studentName}
      console.log "12"
      homework.update { assignmentId: assignmentId, studentName: studentName }, $set: content: content
    else
      homework.insert {
        assignmentId: assignmentId,
        studentName: studentName,
        content: content
      }
}


Meteor.startup ->
  Meteor.users.allow({
    update: (userId,doc) ->
      return true
  })
  assignment.allow {
    insert: (userId, doc) ->
      return true
  }
  if Meteor.is-client
    Meteor.subscribe "userData"
    Session.set 'create', 'false'
    Session.set 'submit', 'false'
    Session.set 'modify', 'false'
  else
    Meteor.publish "userData", ->
      if this.userId
        return Meteor.users.find {_id: this.userId},
                                 {fields: {'status': 1, 'firstName': 1, 'lastName': 1}}
      else
        this.ready!

