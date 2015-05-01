Template['signupview'].helpers {
	havelogin: -> !Session.get 'haveLogin'
	nowuser: -> true
}
Template['signupview'].events {
	'click .signip_': ->
		newUser = {
			username : ($ 'input[name=newname]').val!
			password : ($ 'input[name=newpassword]').val!
			email : ($ 'input[name=newemail]').val!
			roles : ($ 'input[name=newidentity]').val!
		}
		haveone = User.findOne [{username:($ 'input[name=newname]').val!}]
		if haveone 
			alert '用户名已存在！'
		else
			User.insert newUser 
			Session.set 'haveLogin',true
}