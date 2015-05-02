Template['loginview'].helpers {
	havelogin: -> Session.get 'haveLogin'
	nowuser: -> true
}
Template['loginview'].events {
	'click .login_': !->
		usertemp = $ 'input.loginusername' .val!
		password_ =  $ 'input.loginpassword' .val!
		Meteor.loginWithPassword usertemp, password_
	'click .junmptosignupview': !->
		Session.set 'haveLogin', false
}
Session.set 'haveLogin', true
Accounts.onLoginFailure(-> alert '用户名或密码错误！')
Accounts.onLogin(-> alert 'success')