Template.teacher.helpers({
  homeworks: function() {
    return Homeworks.find();
  },
  sums: function() {
    return Submits.find();
  },
});

Template.teacher.events({
  'click .create': function() {
  	$("#homework_form").css('display', 'block');
  	$("#create").css('display', 'none');
    $("input[name=title]").val("");
    $("textarea[name=description]").val("");
    $("input[name=start]").val("");
    $("input[name=end]").val("");
  },
  'click #cancel': function(ev, tpl) {
    ev.preventDefault();
	  $("#create").css('display', 'block');
	  $("#homework_form").css('display', 'none');
  },
  'click #save': function(ev, tpl) {
    ev.preventDefault();
	  var title = $('input[name=title]').val();
	  var author = Meteor.user().username;
  	var description = $('textarea[name=description]').val();
  	var start = $('input[name=start]').val();
  	var end = $('input[name=end]').val();
    if (title == "" || author == "" || description == "" || start == "" || end == "") {
      return;
    }
  	var homework = {
      title       : title,
      author      : author, 
      description : description,
      start       : start,
      end         : end,
      submits     : '0'
	  }
    if (typeof(Homeworks.findOne({title:title})) == 'object') {
	    Homeworks.remove(Homeworks.findOne({title:title})._id);
    }
	  Homeworks.insert(homework);
	  $("#create").css('display', 'block');
	  $("#homework_form").css('display', 'none');
  }
});
