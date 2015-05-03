
if (Meteor.isClient) {

	Template.homework.helpers({
		isSubmit:function() {
			return Session.get("submiting") == this._id;
		},
		isTeacher:function() {
			return Identity.findOne({owner : Meteor.userId()}).identity == 'teacher';
		},
		mySubmit:function() {
			var answer = Submits.findOne({user : Meteor.user().username, question : this.question});
			if(answer)
				return answer.answer;
			else
				return "No Submit";
		},
		myGrade:function() {
			var answer = Submits.findOne({user : Meteor.user().username, question : this.question});
			if(answer)
				return answer.grade;
			else
				return "No Submit";
		}
	});

	Template.homework.events({
		"click #submit":function() {
			if (Session.get("submiting") == this._id)
				Session.set("submiting", "");
			else
				Session.set("submiting", this._id);
		},
		"submit #homework-submit" :function(event) {
			var answer = event.target.answer.value;
			var question = event.target.question.value;
			var haveSubmit = Submits.findOne({user : Meteor.user().username, question : question});
			var theOne = Submits.findOne({question:question, user : Meteor.user().username});
			var theQuestion = HomeWork.findOne({question:question});
			var deadline = theQuestion.deadline;

			var date = new Date();
			var now = new Date();
			deadline = deadline.split('/');
			date.setFullYear(parseInt(deadline[2]),parseInt(deadline[0])-1,parseInt(deadline[1]));
			date.setHours(23);
			date.setMinutes(59);
			date.setSeconds(59);
			date.setMilliseconds(0);


			if (now > date) {
				alert("Hard due is passed. Please contact your teacher if you want to sumit!");
				return;
			}

			if (theOne) {
				Submits.update(theOne._id, {$set: {answer : answer}});
				if(theOne.grade != 'not grade') {
					alert("Already Graded! You can not Submit. Please Contact Your Teacher");
					return;
				}
			} else {
				Submits.insert({
						question : question,
						user : Meteor.user().username,
						answer : answer,
						grade : "not grade",
					});
			}
	
			event.target.answer.value = "";
			alert("submit success!");
			Session.set("submiting", "");
			return false;
		},
		"click .delete": function () {
			HomeWork.remove(this._id);
		}
	});
}