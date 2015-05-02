//var Users = new Mongo.Collection("Users");

Template.register.events({
	'click .btn-rg': function (event) {
		event.preventDefault();
		var username = $('input[name=username]').val();
		var password = $('input[name=password]').val();
		var email = $('input[name=email]').val();
		var firstName = $('input[name=firstName]').val();
		var lastName = $('input[name=lastName]').val();
		var identity = $('select[name=identity]').val();
		var user = Users.findOne({username: username});
		if (user) {
			Session.set("error", "User already exist");
			return false;
		}
		else {
			var newUser = {
			username: username,
			password: password,
			email: email,
			firstName: firstName,
			lastName: lastName,
			identity: identity
		}
			Meteor.call("addUser", newUser);
			/*Users.insert({
				username: username,
				password: password,
				email: email,
				firstName: firstName,
				lastName: lastName,
				identity: identity,
			});*/
			Session.set("username", newUser.username);
			Session.set("state", "home");
			Session.set("error", "");
		}
		return false;
	},
	'click .login': function(event) {
		event.preventDefault();
		Session.set("state", "login");
		Session.set("error", "");
	}
});

Template.register.helpers({
	error: function() {
		return Session.get("error");
	},
});
