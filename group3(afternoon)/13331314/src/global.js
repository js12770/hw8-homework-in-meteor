Identity = new Mongo.Collection("identity");
HomeWork = new Mongo.Collection("homeWork");
Submits = new Mongo.Collection("subimt")

if (Meteor.isClient) {
	Accounts.ui.config({
	  passwordSignupFields: "USERNAME_ONLY"
	});
}
