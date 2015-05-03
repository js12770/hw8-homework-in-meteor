Template.register.events {
	'submit form': (events)-> 
		event.preventDefault!
		usernameVar = events.target.username.value
		passwordVar = events.target.password.value
		firstNameVar = events.target.firstName.value
		lastNameVar = events.target.lastName.value
		roleVar = events.target.role.value
		emailVar = events.target.email.value
		Accounts.createUser {
			username: usernameVar
			password: passwordVar
			profile: {
				'firstName': firstNameVar
				'lastName': lastNameVar
				'role': roleVar
				'email': emailVar
			}
		}
		alert '注册成功'
		Meteor.loginWithPassword usernameVar, passwordVar, ->
			Router.go '/'
			Router.current().render 'home'
}