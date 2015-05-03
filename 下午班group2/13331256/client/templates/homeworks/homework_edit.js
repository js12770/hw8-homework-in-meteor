Template.homeworkEdit.onCreated(function() {
  Session.set('homeworkEditErrors', {});
});

Template.homeworkEdit.helpers({
  errorMessage: function(field) {
    return Session.get('homeworkEditErrors')[field];
  },
  errorClass: function (field) {
    return !!Session.get('homeworkEditErrors')[field] ? 'has-error' : '';
  }
});

Template.homeworkEdit.events({
  'submit form': function(e) {
    e.preventDefault();

    var currentHomeworkId = this._id;

    var homeworkProperties = {
      description: e.target.description.value,
      title: e.target.title.value,
      deadline: e.target.deadline.value
    }

    var errors = validateHomework(homeworkProperties);
    if (errors.title || errors.deadline || errors.description)
      return Session.set('homeworkEditErrors', errors);

    Homeworks.update(currentHomeworkId, {$set: homeworkProperties}, function(error) {
      if (error) {
        alert(error.reason);
      } else {
        Router.go('homeworkPage', {_id: currentHomeworkId});
      }
    });
  },

  'click .delete': function(e) {
    e.preventDefault();

    if (confirm("Delete this homework?")) {
      var currentHomeworkId = this._id;
      Homeworks.remove(currentHomeworkId, function(error) {
        if (error) {
          alert(error.reason);
        } else {
          Router.go('homeworksList');
        }
      });
    }
  }
});
