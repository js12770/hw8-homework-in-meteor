Session.setDefault('status', 'login') if not Session.get('status')

$.fn.serializeJSON = !->
	o = {};
	a = @serializeArray!
	$.each a, !->
		if o[this.name] isnt undefined
			if !o[this.name].push
				o[this.name] = [o[this.name]]
			o[this.name].push(this.value || '')
		else
			o[this.name] = this.value || ''
	return o;

Template['main'].helpers {
	login-page: -> Session.get('status') is 'login'
	register-page: -> Session.get('status') is 'register'
	is-login: -> Session.get('status') is 'online'
	user: -> if Session.get('current-user') then Session.get('current-user') else 'None'
	is-teacher: -> Session.get('current-user').role is 'teacher'
	current-homework: -> Session.get 'current-homework'
}

Template['login'].events {
	'click .link-to-register': (ev, tpl) -> $ '.login-block' .fadeOut !-> Session.set('status', 'register')
	'submit .form-login': (ev, tpl) ->
		ev.prevent-default!
		username = ($ 'input[name=username]').val!
		password = ($ 'input[name=password]').val!
		user = Users.findOne {username: username, password: password}
		if !user
			alert("Username or password invalid!")
		else
			Session.set 'current-user', user
			Session.set 'is-login', true
			Session.set 'status', 'online'
}

Template['register'].events {
	'click .link-to-login': (ev, tpl) -> $ '.register-block' .fadeOut !-> Session.set('status', 'login')
	'submit .form-register': (ev, tpl) !->
		ev.prevent-default!
		register-form = $ '.form-register' .serializeJSON!
		username = ($ 'input[name=username]').val!
		user = Users.findOne {username: username}
		if user
			alert "Username #{username} already exist!"
		else
			user = register-form
			Users.insert user
			Session.set 'current-user', user
			Session.set 'is-login', true
			Session.set 'status', 'online'
}

Template['teacher'].helpers {
	issues: -> Issues.find {user: Session.get('current-user')}
	user: -> if Session.get('current-user') then Session.get('current-user') else 'None'
}

Template['teacher'].on-rendered !-> 
	$ '.datetimepicker' .datetimepicker {format: 'YYYY/MM/DD HH:mm'}
	$ '[data-toggle="tooltip"]' .tooltip();

Template['teacher'].events {
	'click .signout-link': -> Session.set 'current-homework', '' ; Session.set 'status', 'login'
	'submit .issue-form': (ev, tpl) !->
		ev.prevent-default!
		issue-form-in-json = $ '.issue-form' .serializeJSON!
		issue-form-in-json['user'] = Session.get 'current-user'
		Issues.insert issue-form-in-json
		$ '.issue-form input, .issue-form textarea' .val ''
		$ '.modal' .modal 'hide'
}

Template['teacher_issue_item'].events {
	'submit .edit-form': (ev, tpl) ->
		ev.prevent-default!
		edit-form-in-json = $ ev.target .serializeJSON!
		id = edit-form-in-json['id']
		Issues.update {_id: id}, $set: edit-form-in-json
		$ '.modal' .modal 'hide'
	'submit .delete-form': (ev, tpl) ->
		ev.prevent-default!
		delete-form-in-json = $ ev.target .serializeJSON!
		$ '.modal' .modal 'hide'
		# hide modal before it is destoyed
		$ '.modal' .on 'hidden.bs.modal', ->
			Issues.remove {_id: delete-form-in-json['id']}
	'click .grade-btn': (ev, tpl) ->
		id = $ ev.target .attr('issue-id')
		Session.set 'current-homework', id
}

Template['teacher_issue_item'].helpers {
	isoverdue: (deadline) -> deadline <= ((moment new Date()).format 'YYYY/MM/DD HH:mm')
}

Template['student'].helpers {
	user: -> if Session.get('current-user') then Session.get('current-user') else 'None'
	homeworks: ->
		issues = Issues.find!.fetch!
		homeworks = []
		for issue in issues
			submit = Submits.find-one {issueid: issue._id, user: Session.get('current-user')}
			homeworks.push({issue: issue, submit: submit})
		homeworks
}

Template['student'].events {
	'click .signout-link': -> Session.set 'current-homework', '' ; Session.set 'status', 'login'
}

Template['student_item'].events {
	'submit .submit-form': (ev, tpl) ->
		ev.prevent-default!
		submit-form-in-json = $ ev.target .serializeJSON!
		submit-form-in-json['time'] = (moment new Date()).format 'YYYY/MM/DD HH:mm'
		submit-form-in-json['user'] = Session.get 'current-user'
		submit = Submits.find-one {issueid: submit-form-in-json['issueid'], user: submit-form-in-json['user']}
		if submit
			Submits.update {_id: submit._id}, $set: submit-form-in-json
		else
			Submits.insert submit-form-in-json
		$ '.modal' .modal 'hide'
}

Template['student_item'].helpers {
	isoverdue: (deadline) -> deadline <= ((moment new Date()).format 'YYYY/MM/DD HH:mm')
}

Template['grade'].helpers {
	user: -> if Session.get('current-user') then Session.get('current-user') else 'None'
	submits: -> Submits.find {issueid: Session.get('current-homework')}
	title: -> Issues.find-one {_id: Session.get('current-homework')} .title
}

Template['grade'].events {
	'click .go-back-btn': (ev, tpl) -> Session.set 'current-homework', ''
	'click .signout-link': -> Session.set 'current-homework', '' ; Session.set 'status', 'login'
}

Template['submit_item'].events {
	'submit .grade-form': (ev, tpl) ->
		ev.prevent-default!
		grade-form-in-json = $ ev.target .serializeJSON!
		Submits.update {_id: grade-form-in-json['id']} $set: {score: grade-form-in-json['score']}
		$ '.modal' .modal 'hide'
}