function getDateTimeString() {
  var date = new Date();
  var month = (date.getMonth()+1 >= 10) ? date.getMonth()+1 : "0"+(date.getMonth()+1);
  var day = (date.getDate() >= 10) ? date.getDate() : "0"+date.getDate();
  var hour = (date.getHours() >= 10) ? date.getHours() : "0"+date.getHours();
  var minute = (date.getMinutes() >= 10) ? date.getMinutes() : "0"+date.getMinutes();
  var datetime = date.getFullYear()+"-"+month+"-"+day+" "+hour+":"+minute;
  return datetime;
};

Template.student.helpers({
  homeworks: function() {
    return Homeworks.find();
  },
  submits: function() {
    return Submits.find({},{author:Meteor.user().username});
  }
});

Template.student.events({
  'click #submit': function(ev, tpl) {
    ev.preventDefault();
    Session.set('homework_id', ev.target.value);
    $("#"+ev.target.value).css('display', 'block');
  },
  'click #sm': function(ev, tpl) {
    ev.preventDefault();
    homework_id = Session.get('homework_id');
    var author = Meteor.user().username;
    var description = $('textarea[name=description]:visible').val();
    var homework = Homeworks.findOne({_id:homework_id}).title;
    var title = "Submit for "+homework;
    var date = getDateTimeString();
    var submit = {
      _author : author,
      _title  : title,
      _description: description,
      _homework: homework,
      _date : date,
      _grade: null
    }
    if (description == "") {
      return;
    }
    if (typeof Submits.findOne({_homework:homework, _author:author}) == 'object') {
      Submits.remove(Submits.findOne({_homework:homework, _author:author})._id);
    }
    Submits.insert(submit);
    $("#"+homework_id).css('display', 'none');
    Session.set('homework_id', null);
  },
  'click #cancel': function(ev, tpl) {
    ev.preventDefault();
    homework_id = Session.get('homework_id');
	  $("#create").css('display', 'block');
	  $("#"+homework_id).css('display', 'none');
    Session.set('homework_id', null);
  }
});
