Homeworks = new Mongo.Collection('homeworks');

Homeworks.allow({
	insert: function(userId, doc) {
		return (userId && Meteor.user().profile.identity == 'teacher');
	},
	update: function(userId, doc) {
  		return true; // since the 'homework_item.coffee' has already maken sure that a teacher can only edit his own homework.
	}
});