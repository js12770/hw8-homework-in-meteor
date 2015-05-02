if (Meteor.isClient) {
	Template.body.helpers({
		state: function (val) {
			return Session.get("state") === val;
		},
	});
	Meteor.startup(function() {
		Session.set("state", "login");
	});
}
