Users = new Mongo.Collection("Users");
Homeworks = new Mongo.Collection("Homeworks");

Meteor.methods({
	addUser: function(user) {
		var newuser = Users.insert({
			username: user.username,
			password: user.password,
			email: user.email,
			firstName: user.firstName,
			lastName: user.lastName,
			identity: user.identity
		});
		console.log("addUser: ");
		console.log(newuser);
	},
	addHomework: function(homework) {
		var newhomework = Homeworks.insert({
			name: homework.name,
			requirement: homework.requirement,
			deadline: new Date(homework.deadline),
			submit: new Array(),
		});
		console.log("addHomework: ");
		console.log(newhomework);
	},
	updateHomework: function(homework) {
		Homeworks.update(homework._id, homework);
		console.log("updateHomework: ");
		console.log(homework);
	}
});
