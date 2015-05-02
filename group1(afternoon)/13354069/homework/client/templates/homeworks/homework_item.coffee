formateDate = (date) ->
  str = date.getFullYear() + '-'
  month = date.getMonth() + 1
  if date.getMonth() < 10 then str = str + '0' + month + '-' else str = str + month + '-'
  if date.getDate() < 10 then str = str + '0' + date.getDate() else str = str + date.getDate()
  return str

Template.homeworkItem.helpers 
	display: ->
		displayOrNot = ''
		current = formateDate new Date()
		displayOrNot = 'display:none' if current >= @ddl or @teacher isnt "#{Meteor.user().profile.firstName} #{Meteor.user().profile.lastName}"
		displayOrNot