Template['teacher'].events {
	'click .gosetassignment': !->
		$ '.assignment' .add-class 'hidden'
		$ '.setassignment' .remove-class 'hidden'
		$ '#datetimepicker1' .datetimepicker!
		Session.set 'ispublish', true
		setTimeout "UE.getEditor('editor1')", 400
		
}

