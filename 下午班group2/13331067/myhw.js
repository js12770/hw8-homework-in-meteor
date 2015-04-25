// myhw.js
Tasks = new Mongo.Collection("tasks");
Requirements = new Mongo.Collection("requirements");
Submits = new Mongo.Collection("submits");

if (Meteor.isServer) {
  Meteor.startup(
    function() {
      var user1 = {
          username: 'teacher',
          password: 'teacher'
      };
      var user2 = {
          username: 'stu1',
          password: '123123'
      }
      var teacher = Meteor.users.findOne({'username': 'teacher'}),
          stu1 = Meteor.users.findOne({'username': 'stu1'});
      if (!teacher) {
        Accounts.createUser(user1);
      }
      if (!stu1) {
        Accounts.createUser(user2);
      }
  });
}

if (Meteor.isClient) {
  Template.body.helpers({
    requirements_all: function() {
      return Requirements.find({}, {sort: {createdAt: -1}});
    },
    submits_all: function() {
      return Submits.find({}, {sort: {createdAt: -1}});
    },
    submits_own: function() {
      return Submits.find({studentName: Meteor.user().username}, {sort: {createdAt: -1}});
    },
    isTeacher: function () {
      if (Meteor.user().username == 'teacher') return true;
      else return false;
    },
    isStudent: function () {
      if (Meteor.user().username != 'teacher') return true;
      else return false;
    }
  });

  Template.body.events({
    "submit .new-hw-requirement": function (event) {
      var title = event.target.title.value,
          deadline = event.target.deadline.value,
          hwrequirement = event.target.hwrequirement.value;
      var requirement = Requirements.findOne({title: title});
      if (!requirement){
            Requirements.insert({
              title: title,
              deadline: deadline,
              hwrequirement: hwrequirement,
              createdAt: new Date(),
              owner: Meteor.userId(),
              teacherName: Meteor.user().username
            });
      }

      event.target.title.value = "";
      event.target.deadline.value = "";
      event.target.hwrequirement.value = "";

      return false;
    }
  });

  Template.requirement.helpers({
    isTeacher: function () {
      if (Meteor.user().username == 'teacher') return true;
      else return false;
    },
    isStudent: function () {
      if (Meteor.user().username != 'teacher') return true;
      else return false;
    }
  });
  
  Template.requirement.events({
    "submit .submithw": function (event) {
      var hwtitle = event.target.hwtitle.value,
          hwcontent = event.target.hwcontent.value,
          teacherName = event.target.teacherName.value,
          __id = event.target.__id.value;
      var submit = Submits.findOne({studentName: Meteor.user().username, 
                                    hwtitle: hwtitle});

      if (!submit){
        Submits.insert({
          hwtitle: hwtitle,
          hwcontent: hwcontent,
          createdAt: new Date(),
          owner: Meteor.userId(),
          teacherName: teacherName,
          studentName: Meteor.user().username,
          requirementid: __id,
          score: -1
        });
      } else {
        if (submit.score < 0) {
          Submits.update(submit._id, {$set: {'hwcontent': hwcontent}});
        } else {
          alert('作业已经改分了，不允许被修改');
        }
        
      }

      event.target.hwcontent.value = "";
      return false;
    },
    "submit .changeddl": function (event) {
      var newddl = event.target.newddl.value;
      Requirements.update(this._id, {$set: {'deadline': newddl}});
      event.target.newddl.value = '';
      return false;
    }
  });

  Template.hwlist.helpers({
    isTeacher: function () {
      if (Meteor.user().username == 'teacher') return true;
      else return false;
    },
    isStudent: function () {
      if (Meteor.user().username != 'teacher') return true;
      else return false;
    },
    isNotScored: function() {
      if (this.score < 0) return true;
      else return false;
    }
  });

  Template.hwlist.events({
    "submit .givescore": function (event) {
      var newscore = event.target.newscore.value;
      Submits.update(this._id, {$set: {'score': newscore}});
      event.target.newscore.value = "";
      return false;
    }
  });

  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });

}