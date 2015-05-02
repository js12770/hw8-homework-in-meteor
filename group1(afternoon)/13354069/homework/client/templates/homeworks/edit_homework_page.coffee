Template.editHomeworkPage.events 'submit form': (e)->
		e.preventDefault()

		homeworkProperties = 
			description: $(e.target).find('[name=description]').val()
			ddl: $(e.target).find('[name=ddl]').val()

		Homeworks.update @_id,
		  $set: homeworkProperties
		, (error) ->
		  if error then alert error.reason else Router.go "homeworkList"
