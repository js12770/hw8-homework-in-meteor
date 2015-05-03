Template.student.helpers({
	user: function() {
		return Users.findOne({username: Session.get("username")});
	},
	homeworks: function() {
		return Homeworks.find({});
	},
	testOutOfDeadline: function(deadline) {
		return (new Date()) > deadline;
	},
	findLastSubmit: function() {
		var username = Session.get('username');
		for (var data in this.submit)
			if (this.submit[data].username === username)
				return this.submit[data];
	}
});

Template.student.events({
	'click .submitHomework': function(event) {
		event.preventDefault();
		var username = Session.get('username');
		var data;
		for (data = 0; data < this.submit.length; data++)
			if (this.submit[data].username === username) {
				this.submit[data].date = new Date();
				this.submit[data].score = 'none';
				break;
			}
		if (data >= this.submit.length)
			this.submit.push({username: username, date: new Date(), score: 'none', homeworkName: this.name});
		Meteor.call('updateHomework', this);
	}
})