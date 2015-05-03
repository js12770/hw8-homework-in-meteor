Meteor.startup(function () {
	user = {
		username: 'WangQing',
		password: 'teacher',
	};
	if(!Meteor.users.findOne({username:'WangQing'})){
		Accounts.createUser(user);
	}
});