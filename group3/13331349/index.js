Assignments = new Mongo.Collection("assignments")
Submittals = new Mongo.Collection("submittals")

if (Meteor.isClient) {
  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
  Template.registerHelper("isTeacher", function() {
      return Meteor.user().username === "teacher";
    }
  );
  Template.publishAssignment.events({
    "submit form": function (event, template) {
      var title = event.target.title.value;
      var content = event.target.content.value;
      var ddl = event.target.deadline.value;
      var _ddl = new Date(ddl.slice(0, 10) + " " + ddl.slice(11, 16));
      Assignments.insert({
        title     : title,
        content   : content,
        createdAt : new Date(),
        createdAtx: format(new Date()),
        ddl       : new Date(_ddl),
        ddlx      : format(_ddl)
      });
      event.target.title.value = "";
      event.target.content.value = "";
      event.target.deadline.value = "";
      return false;
    },
  });
  Template.showAssignments.helpers({
    assignments: function() {
      return Assignments.find();
    }
  });
  Template.uploadAnswer.events({
    "submit form": function (event, template) {
      var id = event.target.hw_id.value;
      var title = event.target.title.value;
      var answer = event.target.answer.value;
      var current = new Date();
      var ddl = Assignments.find({_id: id}).fetch()[0].ddl;
      if (current > ddl) {
        alert("作业已经截止");
        return false;
      } else {
        Submittals.update({
          _id         : this._id
        },{
          username    : Meteor.user().username,
          hw_id       : id,
          title       : title,
          answer      : answer,
          submittedAt : current,
          submittedAtx: format(current),
          grade       : "未评分"
        },{
          upsert      : true
        });
        event.target.answer.value = "";
        return false;
      }
    }
  });
  Template.uploadContent.events({
    "submit form": function (event, template) {
      var content = event.target.content.value;
      var current = new Date();
      var ddl = this.ddl;
      if (current > ddl) {
        alert("截止时间已到，请勿修改题目内容");
        return false;
      } else {
        Assignments.update({
          _id : this._id
        },{
          $set: {content: content}
        });
        event.target.content.value = "";
        return false;
      }
    },
  });
  Template.uploadDdl.events({
    "submit form": function (event, template) {
      var ddl = event.target.deadline.value;
      var _ddl = new Date(ddl.slice(0, 10) + " " + ddl.slice(11, 16));
      Assignments.update({
        _id : this._id
      },{
        $set: {ddl: _ddl, ddlx: format(_ddl)}
      });
      event.target.deadline.value = "";
      return false;
    },
  });
  Template.uploadedAssignments.helpers({
    submittals: function() {
      return Submittals.find({username: Meteor.user().username});
    },
    submittalsx: function() {
      return Submittals.find({});
    }
  });
  Template.uploadedAssignments.events({
    "submit form": function (event, template) {
      var grade = event.target.grade.value;
      if (isNaN(grade)) {
        alert("请输入数字");
        event.target.grade.value = "";
        return false;
      }
      var current = new Date();
      var ddl = Assignments.find({_id: this.hw_id}).fetch()[0].ddl;
      if (current < ddl) {
        alert("未到截止时间，不能改分");
        return false;
      } else {
        Submittals.update({
          _id : this._id
        },{
          $set: {grade: grade}
        })
        event.target.grade.value = "";
        return false;
      }
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    user = {
      username: 'teacher',
      password: '123456',
    };
    if(!Meteor.users.findOne({username:'teacher'})){
      Accounts.createUser(user);
    }
  });
}

/*auxiliary functions*/
format = function(date) {
  year = exp(date.getFullYear());
  month = exp(date.getMonth() + 1);
  day = exp(date.getDate());
  hour = exp(date.getHours());
  minute = exp(date.getMinutes());
  return year+"/"+month+"/"+day+" "+hour+":"+minute+":00";
}
exp = function(date) {
  var str = date.toString();
  if (str.length < 2)
    str = "0" + str;
  return str;
}