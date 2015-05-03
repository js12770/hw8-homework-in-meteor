Template.homeworkPage.onCreated(function() {
  Session.set('homeworkId', this.data._id);
  Session.set('homeworkDeadline', this.data.deadline);
});

Template.homeworkPage.helpers({
  isStudent: function() {
    return Meteor.user().profile.presence === "student";
  },
  answers: function() {
    if (Meteor.user().profile.presence === "student") return "not allow";
    return this.answers;
  },
  theAnswer: function() {
    for (var i = 0; i < this.answers.length; i++)
      if (this.answers[i].userId == Meteor.userId())
        return this.answers[i];
    return {
      body: "Not answer yet"
    };
  }
});
