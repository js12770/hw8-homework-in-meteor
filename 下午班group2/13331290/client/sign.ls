Template['sign'].events {
	'click .to-sign-up': !->
		$ '.sign-in' .add-class 'hidden'
		$ '.sign-up' .remove-class 'hidden'

	'click .to-sign-in': !->
		$ '.sign-in' .remove-class 'hidden'
		$ '.sign-up' .add-class 'hidden'

	'submit .sign-in': (e)!->
		e.prevent-default!
		Meteor.loginWithPassword e.target.username.value, e.target.password.value

	'submit .sign-up': (e)!->
		e.prevent-default!
		option = 
			username: e.target.username.value
			password: e.target.password.value
			profile:
				id: e.target.id.value
				status:	e.target.status.value
		Meteor.call 'create-user' option
		Meteor.loginWithPassword option.username, option.password
}

