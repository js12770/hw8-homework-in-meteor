Submithw = new Mongo.Collection("submithw");
Publishhw = new Mongo.Collection('publishhw');

if (Meteor.isClient) {
  // This code only runs on the client
  Template.body.helpers({
    hws: function () {
      return Publishhw.find ({}, {sort: {createdAt: -1}});
    },
    isTeacher: function() {
      if(Meteor.user()){
        return Meteor.user().username =='teacher' ? true : false;
      }
    },
    isStudent: function() {
      if(Meteor.user())
        return Meteor.user().username !='teacher' ? true : false;
    }
  });

  Template.hw.helpers({
    submits: function(){
      return Submithw.find ({}, {sort: {createdAt: -1}});
    },
    ifTeacher: function() {
      if(Meteor.user()){
        return Meteor.user().username =='teacher' ? true : false;
      }
    },
    ifStudent: function() {
      if(Meteor.user()){
        return Meteor.user().username !='teacher' ? true : false;
      }
    }
  })

  Template.body.events({
    //老师发布作业
    "submit .new-hw": function (event) {
      // This function is called when the new task form is submitted

      Publishhw.insert({
        hwname: event.target.hwname.value,
        request: event.target.hwrequest.value,
        ddl : event.target.ddl.value,
        createdAt: new Date(),            // current time
        owner: Meteor.userId(),           // _id of logged in user
        username: Meteor.user().username  // username of logged in user
      });

      // Clear form
      event.target.hwname.value = "";
      event.target.hwrequest.value = "";
      event.target.ddl.value = "";

      // Prevent default form submit
      return false;
    }
  });

  Template.hw.events({
    //学生提交作业
    "submit .new-essay": function (event) {
      Submithw.insert({
        essay: event.target.text.value,
        hwid : event.target.hwid.value,
        hwname : event.target.hwname.value,
        mark : null,
        createdAt: new Date(),            // current time
        owner: Meteor.userId(),           // _id of logged in user
        username: Meteor.user().username  // username of logged in user
      });

      // Clear form
      event.target.text.value = "";

      // Prevent default form submit
      return false;
    }
  });
  Template.sub.events({
    "submit .mark": function(event){
      var hw = Submithw.find({ hwid : event.target.hwid.value , username: event.target.studentname.value });
      console.log(hw[0]);

      event.target.mark.value = "";
    return false;
    }
  });

  Accounts.ui.config({
    passwordSignupFields: "USERNAME_AND_EMAIL"
  });
}