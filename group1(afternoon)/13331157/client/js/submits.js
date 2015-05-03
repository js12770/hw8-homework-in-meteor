function getDateTimeString() {
	var date = new Date();
	var month = (date.getMonth()+1 >= 10) ? date.getMonth()+1 : "0"+(date.getMonth()+1);
	var day = (date.getDate() >= 10) ? date.getDate() : "0"+date.getDate();
	var hour = (date.getHours() >= 10) ? date.getHours() : "0"+date.getHours();
	var minute = (date.getMinutes() >= 10) ? date.getMinutes() : "0"+date.getMinutes();
	var datetime = date.getFullYear()+"-"+month+"-"+day+" "+hour+":"+minute;
	return datetime;
};

Template.submit2.helpers({
  isPass: function() {
  	var e = new Date();
    var homework = Homeworks.findOne({title: this._homework});
  	if (homework.end < getDateTimeString()) {
  		return true;
  	} else {
  		return false;
  	}
  }
});

Template.submit2.events({
  'click .give_grade': function(ev, tpl) {
    var homework_id = ev.target.value;
    var grade = $('#'+homework_id).val();
    Submits.update(homework_id, {$set: {_grade: grade}});
    $('#'+homework_id).val("");
  }
});
