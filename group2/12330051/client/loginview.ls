Template['loginview'].helpers {
	havelogin: -> Session.get 'haveLogin'
	nowuser: -> true
}
Template['loginview'].events {
	'click .login_': !->
		usertemp = {
		username: $ 'input.loginusername' .val!
		}
		password_ =  $ 'input.loginpassword' .val!
		Meteor.loginWithPassword {usertemp}, password_
	'click .junmptosignupview': !->
		alert 'j'
		Session.set 'haveLogin', false
}
Session.set 'haveLogin', true
Accounts.onLoginFailure(-> alert '用户名或密码错误！')