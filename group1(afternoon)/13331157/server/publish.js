Meteor.publish('homeworks', function() {
  return Homeworks.find({}, {sort: {start: -1} });
});

Meteor.publish('submits', function(author) {
  if (Roles.userIsInRole(author, ['teacher'])) {
    return Submits.find({});
  } else {
  	var authorName = Meteor.users.findOne({_id:author}).username;
  	return Submits.find({_author:authorName});
  }
});
