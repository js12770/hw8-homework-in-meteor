
if (Meteor.isClient) {
	Template.manage.events({
		"submit #publish":function(event) {
			var question = event.target.question.value;
			var requirement = event.target.requirement.value;
			var deadline = event.target.deadline.value;

			HomeWork.insert({
				teacher: Meteor.user().username,
				question:question,
				requirement:requirement,
				deadline:deadline
			});
			console.log(event);
			return false;
		},
		"submit #update": function (event) {
			var question = event.target.question.value;
			var requirement = event.target.requirement.value;
			var deadline = event.target.deadline.value;
			theOne = HomeWork.findOne({question:question});
			HomeWork.update(theOne._id, {$set: {requirement:requirement}});
			HomeWork.update(theOne._id, {$set: {deadline:deadline}});
			console.log(theOne._id);
			return false;
		}
	});
}