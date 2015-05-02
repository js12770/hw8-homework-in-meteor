Template.register.events {
	'click .button.submit': (events)-> 
		events.prevent-default!
		usernameVar = events.target.username.value
		passwordVar = events.target.password.value
		firstNameVar = events.target.firstName.value
		lastNameVar = events.target.lastName.value
		roleVar = events.target.role.value
		emailVar = events.target.email.value
		Accounts.createUser {
			email: emailVar
			password: passwordVar
			firstName: firstNameVar
			lastName: lastNameVar
			role: roleVar
			username: usernameVar
		}
}