Meteor.publish 'Assignment', ->
  Assignment.find!

Meteor.publish 'Homework', ->
  Homework.find!