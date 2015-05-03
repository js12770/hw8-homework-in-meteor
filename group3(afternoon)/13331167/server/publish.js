Meteor.publish('homeworks', function() {
  return Homeworks.find();
});
Meteor.publish('assignments', function() {
  return Assignments.find();
});