Template.homeworksList.helpers({
  homeworks: function() {
    return Homeworks.find({}, {sort: {submitted: -1}});
  }
});
