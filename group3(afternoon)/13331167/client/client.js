Meteor.subscribe("homeworks");
Meteor.subscribe("assignments");

Template.Home.helpers({
  admin: function () {
    return (Meteor.user().username == 'admin');
  },
  assignments: function () {
    return Assignments.find();
  }
});

Template.Student.helpers({
  assignment: function () {
    var assignmentId = Session.get('assignmentId');
    return Assignments.findOne({_id: assignmentId});
  },
  isSubmitted: function() {
    var assignmentId = Session.get('assignmentId');
    return Homeworks.find({assignmentId: assignmentId, owner: Meteor.userId()}).fetch().length;
  },
  homework: function() {
    var assignmentId = Session.get('assignmentId');
    return Homeworks.findOne({assignmentId: assignmentId, owner: Meteor.userId()});
  },
  isntPassed: function() {
    var assignmentId = Session.get('assignmentId');
    var current_time = moment().format("YYYY/MM/DD HH:mm");
    var deadline = Assignments.findOne({_id: assignmentId}).assignmentDeadline;
    return deadline > current_time;
  }
});

Template.Student_update.helpers({
  assignment: function () {
    var assignmentId = Session.get('assignmentId');
    return Assignments.findOne({_id: assignmentId});
  },
  homework: function() {
    var assignmentId = Session.get('assignmentId');
    return Homeworks.findOne({assignmentId: assignmentId, owner: Meteor.userId()});
  }
});

Template.Student.events({
  "click .submit-homework": function() {
    var studentName = Meteor.user().username;
    var content = $('.homework-content').val();
    var assignmentId = Session.get('assignmentId');
    if (content) {
      Meteor.call("addHomework", studentName, content, assignmentId);
      $('.warning').addClass('hide').removeClass('show');
    } else {
      $('.warning').addClass('show').removeClass('hide');
    }
  }
});

Template.Student_update.events({
  "click .update-homework": function() {
    var content = $('.homework-content').val();
    var homeworkID = $('.homework-id').val();
    if (content) {
      Meteor.call("updateHomework", homeworkID, content);
      $('.warning').addClass('hide').removeClass('show');
      window.history.back(-1);
    } else {
      $('.warning').addClass('show').removeClass('hide');
    }
  }
});

Template.New_assignment.events({
  "click .submit-assignment": function() {
    var assignmentName = $('#assignment-name').val();
    var assignmentContent = $('#assignment-content').val();
    var assgnmentDeadline = $('#assignment-deadline').val();
    if (assignmentName && assignmentContent && assgnmentDeadline) {
      Meteor.call("addAssignment",assignmentName, assignmentContent, assgnmentDeadline);
      $('.warning').addClass('hide').removeClass('show');
      window.history.back(-1);
    } else {
      $('.warning').addClass('show').removeClass('hide');
    }
    
  }
});

Template.New_assignment.onRendered(function() {
  $('#assignment-deadline').datetimepicker();
});

Template.Teacher.helpers({
  assignment: function () {
    var assignmentId = Session.get('assignmentId');
    return Assignments.findOne({_id: assignmentId});
  },
  isSubmitted: function() {
    var assignmentId = Session.get('assignmentId');
    return Homeworks.find({assignmentId: assignmentId}).fetch().length;
  },
  homeworks: function() {
    var assignmentId = Session.get('assignmentId');
    return Homeworks.find({assignmentId: assignmentId});
  },
  isntPassed: function() {
    var assignmentId = Session.get('assignmentId');
    var current_time = moment().format("YYYY/MM/DD HH:mm");
    var deadline = Assignments.findOne({_id: assignmentId}).assignmentDeadline;
    return deadline > current_time;
  }
});

Template.Teacher.events({
  "click .score": function(e) {
    var score = $(e.target).siblings('.homework-score').val();
    if (!score || isNaN(score)) {
      $(e.target).siblings('.warning').removeClass('hide').addClass('show');
    } else {
      $(e.target).siblings('.warning').addClass('hide').removeClass('show');
      var homeworkID = $(e.target).siblings('.homework-id').val();
      Meteor.call("scoreHomework", homeworkID, score);
      $(e.target).siblings('.homework-score').val('');
    }
    
  }
});

Template.Update_assignment.helpers({
  assignment: function () {
    var assignmentId = Session.get('assignmentId');
    return Assignments.findOne({_id: assignmentId});
  }
});

Template.Update_assignment.events({
  "click .update-assignment": function() {
    var assignmentName = $('#assignment-name').val();
    var assignmentContent = $('#assignment-content').val();
    var assgnmentDeadline = $('#assignment-deadline').val();
    var assignmentId = Session.get('assignmentId');
    if (assignmentName && assignmentContent && assgnmentDeadline) {
      Meteor.call("uppdateAssignment", assignmentId, assignmentName, assignmentContent, assgnmentDeadline);
      $('.warning').addClass('hide').removeClass('show');
      window.history.back(-1);
    } else {
      $('.warning').addClass('show').removeClass('hide');
    }
  }
});

Template.Update_assignment.onRendered(function() {
  $('#assignment-deadline').datetimepicker();
});

Template.Assignments.events({
  "click .enter": function () {
    Session.set('assignmentId', this._id);
  }
});

Accounts.ui.config({
  passwordSignupFields: "USERNAME_ONLY"
});
