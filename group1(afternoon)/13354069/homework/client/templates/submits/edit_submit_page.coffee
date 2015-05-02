Template.editSubmitPage.events 'submit form': (e)->
		e.preventDefault()

		submitProperties = 
			content: $(e.target).find('[name=content]').val()

		Submits.update @_id,
		  $set: submitProperties
		, (error) ->
		  if error then alert error.reason else Router.go "submitsList"
