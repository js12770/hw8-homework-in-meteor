Submits = new Mongo.Collection('submits');

Submits.allow({
	insert: function(userId, doc) {
		return true;
	},
	update: function(userId, doc) {
  		return true; // since the 'submit_item.coffee' has already maken sure that a student can only edit his own homework.
	}
});