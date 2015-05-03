Template.homeworkItem.helpers({
  owner: function() {
    return this.userId === Meteor.userId();
  },
  buttonTips: function() {
    if (Meteor.user().profile.presence === "student") return "Answer it";
    else return this.answers.length + " students haved answered"
  },
  deadline: function() {
    var a = (new Date()).getTime() - (new Date(this.deadline)).getTime();
    var tip = " ago";
    if (a < 0) { tip = " late"; a = -a; }
    var days = Math.floor(a/(24*3600*1000));
    var hours = Math.floor( (a%(24*3600*1000)) / (3600*1000) );

    return "End at " + days + " days and " + hours + " hours" + tip;
  }
});
