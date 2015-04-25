Template['register'].events({
	'submit form':(evt)!->
		evt.preventDefault!;
		Accounts.createUser({username: ($ 'input[name=username]').val!, 
		password: ($ 'input[name=password]').val!});
		Router.go('home');
});