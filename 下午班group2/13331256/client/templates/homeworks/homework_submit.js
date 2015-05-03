Template.homeworkSubmit.onCreated(function() {
  Session.set('homeworkSubmitErrors', {});
});

Template.homeworkSubmit.helpers({
  errorMessage: function(field) {
    return Session.get('homeworkSubmitErrors')[field];
  },
  errorClass: function(field) {
    return !!Session.get('homeworkSubmitErrors')[field] ? 'has-error' : '';
  },
  dateNow: function() {
    return new Date();
  }
});

Template.homeworkSubmit.events({
    'submit form': function(e) {
        e.preventDefault();

        var homework = {
            deadline: e.target.deadline.value,
            title: e.target.title.value,
            description: e.target.description.value
        };

        var errors = validateHomework(homework);
        if (errors.title || errors.deadline || errors.description) return Session.set('homeworkSubmitErrors', errors);
        
        Meteor.call('homeworkInsert', homework, function(error, result) {
            if (error) return throwError(error.reason);
            Router.go('homeworkPage', {_id: result._id});
        });
    }
});
