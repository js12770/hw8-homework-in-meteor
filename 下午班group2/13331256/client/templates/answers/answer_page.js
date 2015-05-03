Template.answerPage.onCreated(function() {
  Session.set('answerSubmitErrors', {});
});

Template.answerPage.helpers({
  errorMessage: function(field) {
    return Session.get('answerSubmitErrors')[field];
  },
  errorClass: function (field) {
    return !!Session.get('answerSubmitErrors')[field] ? 'has-error' : '';
  },
  isDisabled: function() {
    return new Date(Session.get('homeworkDeadline')) < new Date();
  },
  score: function() {
    return this.score ? this.score : "No score yet"
  }
});

Template.answerPage.events({
  'submit form': function(e, template) {
    e.preventDefault();

    var answer = {
      body: e.target.answer.value
    };

    var errors = {};
    if (! answer.body) {
      errors.body = "Please write some content";
      return Session.set('answerSubmitErrors', errors);
    }

    Meteor.call('answerInsert', answer, Session.get('homeworkId'), function(error, answerId) {
      if (error){
        throwError(error.reason);
      } else {
        Router.go('homeworkPage', {_id: Session.get('homeworkId')});
      }
    });
  }
});
