Projects = new Meteor.Collection 'Projects'
Handins = new Meteor.Collection 'Handins'

if Meteor.isClient
	Template.deadlineCreate.events ( {
		'click #ddcommit': !->
			name = ($ 'input[name=name]').val!
			req = ($ 'input[name=require]').val!
			date = ($ '#mdate').val!
			day = date.split('T')[0].split('-')
			time = date.split('T')[1].split(':')
			mdate = new Date()
			mdate.setFullYear(day[0], day[1], day[2])
			mdate.setHours(time[0], time[1])
			homework = {'name': name, 'requirement':req, 'deadline':mdate}
			Projects.insert homework}
	)
	Template.deadlineView.plist = ->
		pd = []
		homeworks = Projects.find!.fetch!
		for i from 0 to homeworks.length-1
			date-now = new Date
			a = homeworks[i].deadline.valueOf!
			b = date-now.valueOf!
			if a < b
				pd.push homeworks[i]
		return pd
	Template.deadlineView.olist = ->
		d = []
		homeworks = Projects.find!.fetch!
		for i from 0 to homeworks.length-1
			date-now = new Date
			if homeworks[i].deadline.valueOf! > date-now.valueOf!
				d.push homeworks[i]
		return d
	Template.upload.events (
		'click #hcommit': !->
			file = ($ 'textarea[name=file]').val!
			owner = Meteor.userId!
			name = Session.get 'homeworkname'
			handin = {'name':name, 'owner':owner, 'file':file}
			oldHandin = Handins.find-one 'name':name, 'owner':owner
			if oldHandin
				Handins.update {name:name, owner:owner}, $set: file:file
			else
				Handins.insert handin
	)
	Template['upload'].helpers {
		oldfile : ->
			name = Session.get 'homeworkname'
			owner = Meteor.userId!
			oldHandin = Handins.find-one 'name':name, 'owner':owner
			if oldHandin
				oldfile = oldHandin.file
			else
				oldfile = 'no handin yet'
			$('#oldfile').html(oldfile)
			oldfile
	}
	Template.deadlineView.events({
		'click .handin': !->
			name = this.name
			Session.set 'homeworkname', name
	})
	Template.upload.homeworkname = !->
		homeworkname = Session.get 'homeworkname'
		return homeworkname
	Template.deadlineView.helpers ( {
		username : ->
			return Meteor.user() && Meteor.user().username
		}
	)
	Accounts.ui.config({
		passwordSignupFields: "USERNAME_ONLY"
	})
