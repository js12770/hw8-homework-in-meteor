function getDateTimeString() {
	var date = new Date();
	var month = (date.getMonth()+1 >= 10) ? date.getMonth()+1 : "0"+(date.getMonth()+1);
	var day = (date.getDate() >= 10) ? date.getDate() : "0"+date.getDate();
	var hour = (date.getHours() >= 10) ? date.getHours() : "0"+date.getHours();
	var minute = (date.getMinutes() >= 10) ? date.getMinutes() : "0"+date.getMinutes();
	var datetime = date.getFullYear()+"-"+month+"-"+day+" "+hour+":"+minute;
	return datetime;
};

Template.homework.helpers({
  isPass: function() {
  	var e = new Date();
  	if (this.end < getDateTimeString()) {
  		return true;
  	} else {
  		return false;
  	}
  }
});
Template.homework.events({
  'click #edit':function(ev, tpl) {
   	$("#homework_form").css('display', 'block');
	  $("#create").css('display', 'none');
    $("input[name=title]").val(this.title);
    $("textarea[name=description]").val(this.description).focus();
    $("input[name=start]").val(this.start);
    $("input[name=end]").val(this.end);
  }
});
