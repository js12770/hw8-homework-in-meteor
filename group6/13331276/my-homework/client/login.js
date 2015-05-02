Users = new Mongo.Collection("Users");
Template.login.events({
	'click .btn-lg': function (event) {
		var username = $('input[name=username]').val();
		var password = $('input[name=password]').val();
		var user = Users.findOne({username: username})
		if (user) {
			if (user.password == password) {
				Session.set("state", "home");
				Session.set("username", username);
				Session.set("error", "");
			}
			else
				Session.set("error", "Password Error")
		}
		else {
			Session.set("error", "No such user");
		}
		return false;
	},
	'click .new-account': function (event) {
		event.preventDefault();
		Session.set("state", "register");
		Session.set("error", "");
		return false;
	}
});

Template.login.helpers({
	error: function() {
		return Session.get("error");
	},
});
