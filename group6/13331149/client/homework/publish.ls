Template.publish.events {
	'submit form': (events)->
		events.prevent-default!
		hwname = events.target.hwname.value
		date = events.target.date.value
		time = events.target.time.value
		command = events.target.command.value
		homework = Homeworks.findOne $or: [{hwname}]
		if homework then alert "Can't add homework: #{hwname} anymore, cause (s)it's already added." else
			Homeworks.insert homework = {hwname:hwname, date:date, time:time, command:command, submits: []}			
			Router.go '/homework/showhw	'
}