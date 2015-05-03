
if (Meteor.isClient) {
	Template.confirm.events({
		"submit .identity": function (event) {
			var identity = event.target.role.value;
			console.log(Identity);
			Identity.insert({
				identity: identity,
				owner: Meteor.userId(),
				username: Meteor.user().username
			});
			Session.set("confirm", "confirmed");
			return false;
		},
	});
}