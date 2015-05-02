Template.login.events {
	'submit form': (event)->
		event.preventDefault!
		usernameVar = event.target.username.value
		passwordVar = event.target.password.value
		Meteor.loginWithPassword usernameVar, passwordVar, (error)-> 
			if error 
				alert error
				Router.go 'login'
			else
				Router.go '/'
}