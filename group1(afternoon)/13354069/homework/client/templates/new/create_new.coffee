formateDate = (date) ->
  str = date.getFullYear() + '-'
  month = date.getMonth() + 1
  if date.getMonth() < 10 then str = str + '0' + month + '-' else str = str + month + '-'
  if date.getDate() < 10 then str = str + '0' + date.getDate() else str = str + date.getDate()
  return str

Template.createNew.helpers
	label: ->
		if Meteor.user().profile.identity is 'teacher' then return 'Description' else return 'Content'
	isTeacher: ->
		return Meteor.user().profile.identity is 'teacher'

Template.createNew.events
	'submit form': (e)->
		e.preventDefault()
		
		if Meteor.user().profile.identity is 'teacher'
			hwName = $(e.target).find('[name=name]').val()
			homeworkAlreadyExisted = Homeworks.findOne name: hwName

			if homeworkAlreadyExisted
				alert 'This homework has already existed. Please check the name.'
			else
				homework = 
					name: hwName
					teacher: "#{Meteor.user().profile.firstName} #{Meteor.user().profile.lastName}"
					description: $(e.target).find('[name=description]').val()
					start: formateDate new Date()
					ddl: $(e.target).find('[name=ddl]').val()

				homework._id = Homeworks.insert homework
				Router.go 'homeworkList', Homeworks

		else if Meteor.user().profile.identity is 'student'
			hwName = $(e.target).find('[name=name]').val()
			submitAlreadyExisted = Submits.findOne name: hwName
			hw = Homeworks.findOne name: hwName
			current = formateDate new Date()

			if not hw
				alert "No homework named " + hwName + ". Please check the name."
			else if hw.ddl <= current
				alert "You can not submit it. Since the DDl fo the homework is over."
			else if submitAlreadyExisted
				alert 'This submit has already existed. Please check the name.'
			else
				submit = 
					name: hwName
					student: "#{Meteor.user().profile.firstName} #{Meteor.user().profile.lastName}"
					content: $(e.target).find('[name=description]').val()
					latest: formateDate new Date()
					ddl: hw.ddl

				submit._id = Submits.insert submit
				Router.go 'submitsList', Submits