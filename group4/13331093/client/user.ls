Template['user'].events {
	'click .goregist': !->
		$ '.l' .add-class 'hidden'
		$ '.r' .remove-class 'hidden'

	'submit .log': (e)!->
		e.prevent-default!
		u = users.findOne {"username" : e.target.username.value, "password" : e.target.password.value}
		if u
			alert "登陆成功"
			Session.set 'currentuser', u
		else
			alert "登陆失败"


	'submit .reg': (e)!->
		e.prevent-default!
		infor = 
			username: e.target.username.value
			password: e.target.password.value
			email: e.target.email.value
			firstName: e.target.firstName.value
			lastName: e.target.lastName.value
			identity: e.target.identity.value
		if users.findOne {"username" : e.target.username.value}
			alert "已有存在相同的用户"
		else
			Session.set 'currentuser', infor
			users.insert infor
}

