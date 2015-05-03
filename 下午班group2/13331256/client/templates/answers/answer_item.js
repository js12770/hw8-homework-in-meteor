Template.answerItem.helpers({
  submittedText: function() {
    return this.submitted.toString();
  },
  score: function() {
    return this.score ? this.score : "No score yet"
  },
  isDisabled: function() {
    return new Date(Session.get('homeworkDeadline')) > new Date();
  }
});

Template.answerItem.events({
  "submit .form": function(e) {
    e.preventDefault();

    score = parseInt(e.target.score.value);
    if (!isNaN(score)) {
      Meteor.call('scoreUpdate', Session.get('homeworkId'), this.userId, score);
    } else {
      alert("Pelease enter a number.");
    }
  }
});
