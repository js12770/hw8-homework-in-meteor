Template.home.helpers({
	identity: function(val, user) {
		return val === user.identity;
	},
	user: function() {
		return Users.findOne({username: Session.get("username")});
	}
});

Template.home.events({
	'click .signout': function(event) {
		event.preventDefault();
		Session.set("state", "login");
	},
})