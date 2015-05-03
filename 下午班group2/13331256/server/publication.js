Meteor.publish('homeworks', function() {
    return Homeworks.find();
});

// Meteor.publish('comments', function() {
//   return Comments.find();
// });