if (Meteor.isClient) {
	Template.manage.rendered = function() {
		$('#datepicker1').datepicker();
		$('#datepicker2').datepicker();
	}
}