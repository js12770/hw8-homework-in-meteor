formateDate = (date) ->
  str = date.getFullYear() + '-'
  month = date.getMonth() + 1
  if date.getMonth() < 10 then str = str + '0' + month + '-' else str = str + month + '-'
  if date.getDate() < 10 then str = str + '0' + date.getDate() else str = str + date.getDate()
  return str

Template.submitItem.helpers 
	shouldBeScored: ->
		current = formateDate new Date()
		hw = Homeworks.findOne name: @name
		if hw then return Meteor.user().profile.identity is 'teacher' and @ddl <= current and !@score else return false

	scored: ->
		current = formateDate new Date()
		if current >= @ddl and not @score 
			return "Hasn't been socred." 
		else if current < @ddl
			return ''
		else 
			return "Score: #{@score}"

	display: ->
		displayOrNot = ''
		current = formateDate new Date()
		displayOrNot = 'display:none' if current >= @ddl or @student isnt "#{Meteor.user().profile.firstName} #{Meteor.user().profile.lastName}"
		displayOrNot

Template.submitItem.events
	'submit form': (e)->
		e.preventDefault()
		
		submitProperties = 
			score: $(e.target).find('[name=score]').val()

		Submits.update @_id,
		  $set: submitProperties
		, (error) ->
		  if error then alert error.reason else Router.go "submitsList"