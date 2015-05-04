Requirements = new Mongo.Collection("requirements");
Homeworks = new Mongo.Collection("homeworks");

if (Meteor.isClient) {
  Meteor.subscribe("requirements");
  Meteor.subscribe("homeworks");
  Meteor.subscribe("userData");

  Template.body.helpers({
    userType: function () {
      return Meteor.user().type || "No user type";
    },
    isNotSetType: function () {
      return !Meteor.user().type;
    },
    isTeacher: function () {
      return Meteor.user().type == "teachers";
    },
    isStudent: function () {
      return Meteor.user().type == "students";
    }
  });


  Template.requirement.helpers({
    requirements: function () {
      return Requirements.find();
    },
    isOwner: function () {
      return this.teacher === Meteor.user().username;
    }
  });


  Template.typeCheck.helpers({
    isNotSetType: function () {
      return !Meteor.user().type;
    }
  });


  Template.body.events({
    "submit .get-user-type": function (event) {
      var type = "";
      if (event.target.user_type[0].checked == true) {
        type = event.target.user_type[0].value;
      } else {
        type = event.target.user_type[1].value;
      }
      Meteor.call("addType", type);
      return false;
    }
  });


  Template.requirement.events({
    "click .delete": function () {
      Meteor.call("deleteRequirement", this._id);
    },
    "submit .submit-homework": function () {
      var content = event.target.homework.value;
      var teacher = "";
      Meteor.call("addHomework", content, teacher);
      event.target.homework.value = "";
      return false;
    }
  });


  Template.addRequirements.events({
    "submit .new-requirements": function () {
      var title = event.target.title.value;
      var deadline = event.target.deadline.value;
      var content = event.target.content.value;
      Meteor.call("addRequirement", title, deadline, content);
      event.target.title.value = "";
      event.target.deadline.value = "";
      event.target.content.value = "";
      return false;
    }
  });


  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
}


// ------------------------------------------------------------


if (Meteor.isServer) {
  Meteor.publish("userData", function () {
    if (this.userId) {
      return Meteor.users.find({_id: this.userId},
        {fields: {"type": 1}});
    } else {
      this.ready();
    }
  });
  Meteor.publish("requirements", function () {
    return Requirements.find();
  });
  Meteor.publish("homeworks", function () {
    return Homeworks.find();
  });
}


// ------------------------------------------------------------


Meteor.methods({
  addType: function (type) {
    if (! Meteor.userId()) {
      throw new Meteor.Error("not-authorized");
    }
    Meteor.users.update({username: Meteor.user().username}, {$set: {type: type}});
  },
  addRequirement: function (title, deadline, content) {
    if (! Meteor.userId()) {
      throw new Meteor.Error("not-authorized");
    }

    Requirements.insert({
      title: title,
      deadline: deadline,
      content: content,
      teacher: Meteor.user().username,
      createDate: new Date()
    });
  },
  deleteRequirement: function (requirementId) {
    var requirement = Requirements.findOne(requirementId);
    Requirements.remove(requirementId);
  },
  addHomework: function (content, teacher) {
    Homeworks.insert({
      student: Meteor.user().username,
      content: content,
      teacher: teacher,
      createDate: new Date()
    });
  }
});