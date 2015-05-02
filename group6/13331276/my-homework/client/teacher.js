Homeworks = new Mongo.Collection("Homeworks");

Template.teacher.helpers({
	user: function() {
		return Users.findOne({username: Session.get("username")});
	},
	homeworks: function() {
		return Homeworks.find({});
	},
	testOutOfDeadline: function(deadline) {
		return (new Date()) > deadline;
	},
	homeworkCreateError: function() {
		return Session.get("homeworkCreateError");
	},
	allowScoreBeforeDeadline: function() {
		return Session.get("allowScoreBeforeDeadline");
	},
	testOutOfDeadline: function(deadline) {
		return (new Date()) > deadline;
	},
	deadlineOfHomeworkOut: function(homeworkName) {
		var deadline = Homeworks.findOne({name: homeworkName}).deadline
		return (new Date()) > deadline;
	}
});

Template.teacher.events({
	'click .btn-crho': function(event) {
		event.preventDefault();
		var homeworkName = $('input[name=homeworkName]').val();
		var homeworkRequirement = $('input[name=homeworkRequirement]').val();
		var homeworkDeadlineDate = $('input[name=deadlineDate]').val();
		var homeworkDeadlineTime = $('input[name=deadlineTime]').val();
		homeworkDeadline =  homeworkDeadlineDate + " " + homeworkDeadlineTime;
		var homework = Homeworks.findOne({name: homeworkName});
		if (homework) {
			console.log("homework already exist");
			Session.set("homeworkCreateError", "homework already exist");
		} else {
			newHomework = {
				name: homeworkName,
				requirement: homeworkRequirement,
				deadline: homeworkDeadline
			}
			Meteor.call("addHomework", newHomework);
			Session.set("homeworkCreateError", "");
		}
	},
	'submit .newScore': function(event) {
		event.preventDefault();
		var score = event.target.text.value;
		homework = Homeworks.findOne({name: this.homeworkName});
		for (var index in homework.submit) {
			if (homework.submit[index].username === this.username) {
				homework.submit[index].score = score;
			}
		}
		Meteor.call('updateHomework', homework);
	},
	'submit .newDealine': function(event) {
		event.preventDefault();
		var newDealineDate = event.target.newDealineDate.value;
		var newDealineTime = event.target.newDealineTime.value;
		var newHomeworkDeadline = newDealineDate + " "  + newDealineTime;
		this.deadline = new Date(newHomeworkDeadline);
		Meteor.call("updateHomework", this);
	},
	'submit .newRequirement': function(event) {
		event.preventDefault();
		var newRequirement = event.target.text.value;
		this.requirement = newRequirement;
		Meteor.call("updateHomework", this);
	},
	'change .allowScoreBeforeDeadline input': function(event) {
		Session.set("allowScoreBeforeDeadline", event.target.checked);
	},
});