Template['register'].events({
	'submit form':(evt)!->
		evt.preventDefault!;
		/*      student-id = ($ 'input[name=studentId]').val!
      name = ($ 'input[name=name]').val!
      student = Students.findOne $or: [{student-id}, {name}]
      if student then alert "Can't add student: #{student-id}, #{name} anymore, cause (s)he's already added." 
      else
        Students.insert student = {student-id, name}
        Session.set 'current-student', student*/
		u = ($ 'input[name=username]').val!
		p = ($ 'input[name=password]').val!
		e = ($ 'input[name=email]').val!
		l = ($ 'input[name=lastName]').val!
		f = ($ 'input[name=firstName]').val!
		i = ($ 'input[name=identity]').val!
		user = Meteor.users.findOne({username: u})
		if !user
			Accounts.createUser({username: u, password: p});
			Session.set 'current-user', user
			Router.go('home');
		else
			alert("用户名已经被注册！")
});