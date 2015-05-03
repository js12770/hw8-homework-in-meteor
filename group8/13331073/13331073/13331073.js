Homeworks = new Mongo.Collection("homeworks");
Answers = new Mongo.Collection("answers");

if (Meteor.isClient) {
  Meteor.subscribe("homeworks");
  Meteor.subscribe("answers");
  Template.body.helpers({
    homeworks: function () {
      return Homeworks.find({});
    },
    answers: function () {
      var username = Meteor.user().username;
      if(username.charAt(username.length - 1) === 'T') {
        return Answers.find({});
      } else {
        return Answers.find({AnswerAuthor: username});
      }
    }
  });
  Template.createHomework.helpers({
    isTeacher: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) === 'T';
    }
  });
  Template.createHomework.events({
    "submit .new-homework": function (event) {
      var HomeworkTitle = event.target.HomeworkTitle.value;
      var Homework_Deadline = event.target.HomeworkDeadline.value;
      var HomeworkDeadlineValue = (new Date(Homework_Deadline)).valueOf() - 28800000;
      var HomeworkDeadline = new Date((new Date(Homework_Deadline)).valueOf() - 28800000).toLocaleString();
      var HomeworkRequirement = event.target.HomeworkRequirement.value;
      Meteor.call("addHomework", HomeworkTitle, HomeworkDeadline, HomeworkDeadlineValue, HomeworkRequirement);
      event.target.HomeworkTitle.value = "";
      event.target.HomeworkDeadline.value = "";
      event.target.HomeworkRequirement.value = "";
      return false;
    }
  });
  Template.homework.helpers({
    isTeacher: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) === 'T';
    },
    isStudent: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) === 'S';
    },
    isInvalid: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) !== 'S' && username.charAt(username.length - 1) !== 'T';
    }
  });
  Template.homework.events({
    "click .delete": function () {
      Meteor.call("deleteHomework", this._id)
    },
    "submit .changeDeadline": function (event) {
      var new_deadline = event.target.NewDeadline.value;
      if(!new_deadline) return false;
      var homework_deadline_value = (new Date(new_deadline)).valueOf() - 28800000;
      var homework_deadline = new Date((new Date(new_deadline)).valueOf() - 28800000).toLocaleString();
      Meteor.call("changeDeadline", this._id, homework_deadline, homework_deadline_value);
      event.target.NewDeadline.value = "";
      return false;
    },
    "submit .changeRequirement": function (event) {
      var new_requirement = event.target.NewRequirement.value;
      if(!new_requirement) return false;
      Meteor.call("changeRequirement", this._id, new_requirement);
      event.target.NewRequirement.value = "";
      return false;
    },
    "submit .new-answer": function (event) {
      homework = Homeworks.findOne({_id: this._id});
      var AnswerTitle = homework.HomeworkTitle;
      var AnswerAuthor = Meteor.user().username;
      var AnswerContent = event.target.HomeworkAnswer.value;
      Meteor.call("addAnswer", AnswerTitle, AnswerAuthor, AnswerContent);
      event.target.HomeworkAnswer.value = "";
      return false;
    }
  });
  Template.answer.helpers({
    isOwnerOrTeacher: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) === 'T' || this.owner === Meteor.userId();
    },
    isTeacher: function () {
      var username = Meteor.user().username;
      return username.charAt(username.length - 1) === 'T';
    }
  });
  Template.answer.events({
    "click .delete_answer": function () {
      Meteor.call("deleteAnswer", this._id)
    },
    "submit .score": function (event) {
      var score = event.target.AnswerScore.value;
      if(!score) return false;
      Meteor.call("score", this._id, score);
      event.target.AnswerScore.value = "";
      return false;
    }
  });
  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
}

Meteor.methods({
  addHomework: function (HomeworkTitle, HomeworkDeadline, HomeworkDeadlineValue, HomeworkRequirement) {
    if(Homeworks.findOne({HomeworkTitle: HomeworkTitle})) return;
    var username = Meteor.user().username;
    if(username.charAt(username.length - 1) !== 'T') return;
    Homeworks.insert({
      HomeworkTitle: HomeworkTitle,
      HomeworkDeadline: HomeworkDeadline,
      HomeworkDeadlineValue: HomeworkDeadlineValue,
      HomeworkRequirement: HomeworkRequirement,
      createdAt: new Date(),
      owner: Meteor.userId(),
      username: Meteor.user().username
    });
  },
  deleteHomework: function (taskId) {
    Homeworks.remove(taskId);
  },
  changeDeadline: function (taskId, homework_deadline, homework_deadline_value) {
    var now_time = (new Date()).valueOf();
    var deadline = Homeworks.findOne({_id: taskId}).HomeworkDeadlineValue;
    if(deadline < now_time) return;
    var homework = Homeworks.findOne({_id: taskId});
    var answers = Answers.find({AnswerTitle: homework.HomeworkTitle});
    Homeworks.update(taskId, { $set: { HomeworkDeadline: homework_deadline, HomeworkDeadlineValue: homework_deadline_value } })
  },
  changeRequirement: function (taskId, new_requirement) {
    var now_time = (new Date()).valueOf();
    var deadline = Homeworks.findOne({_id: taskId}).HomeworkDeadlineValue;
    if(deadline < now_time) return;
    Homeworks.update(taskId, { $set: { HomeworkRequirement: new_requirement} })
  },
  addAnswer: function (AnswerTitle, AnswerAuthor, AnswerContent) {
    if(Answers.findOne({AnswerTitle: AnswerTitle, AnswerAuthor: AnswerAuthor})) {
      answer = Answers.findOne({AnswerTitle: AnswerTitle, AnswerAuthor: AnswerAuthor});
      Answers.update(answer._id, { $set: { AnswerContent: AnswerContent} })
      return;
    }
    var now_time = (new Date()).valueOf();
    var deadline = Homeworks.findOne({HomeworkTitle: AnswerTitle}).HomeworkDeadline;
    if(deadline < now_time) return;
    Answers.insert({
      AnswerTitle: AnswerTitle,
      AnswerAuthor: AnswerAuthor,
      AnswerContent: AnswerContent,
      AnswerScore: "Teacher has not given points yet",
      createdAt: new Date(),
      owner: Meteor.userId(),
      username: Meteor.user().username
    });
  },
  deleteAnswer: function (taskId) {
    Answers.remove(taskId);
  },
  score: function (taskId, score) {
    var now_time = (new Date()).valueOf();
    var HomeworkTitle = Answers.findOne({_id: taskId}).AnswerTitle;
    var deadline = Homeworks.findOne({HomeworkTitle: HomeworkTitle}).HomeworkDeadlineValue;
    if(deadline >= now_time) return;
    Answers.update(taskId, { $set: { AnswerScore: score} })
  }
});

if (Meteor.isServer) {
  Meteor.publish("homeworks", function () {
    return Homeworks.find();
  });
  Meteor.publish("answers", function () {
    return Answers.find();
  });
}