Projects = new Meteor.Collection 'Projects'
Handins = new Meteor.Collection 'Handins'


Projects.allow ({
	update: -> true ,
	insert: -> true
})
Handins.allow ({
	update: -> true ,
	insert: -> true
})

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
			usernow = Meteor.user().username
			hwname = homeworks[i].name
			draft = Handins.find-one {name:hwname, owner:usernow}
			if draft
				score = draft.score
				if !score
					score = 'No score yet'
			else
				score = 'You handin nothing'
			myhwid = homeworks[i]._id
			Projects.update {_id:myhwid} $set: score:score
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
			owner = Meteor.user().username
			name = Session.get 'homeworkname'
			handin = {'name':name, 'owner':owner, 'file':file}
			oldHandin = Handins.find-one 'name':name, 'owner':owner
			if oldHandin
				id = oldHandin._id
				Handins.update {_id:id}, $set: file:file
			else
				Handins.insert handin
	)
	Template['upload'].helpers {
		oldfile : ->
			name = Session.get 'homeworkname'
			owner = Meteor.user().username
			oldHandin = Handins.find-one 'name':name, 'owner':owner
			if oldHandin
				oldfile = oldHandin.file
			else
				oldfile = 'no handin yet'
			/*$('#oldfile').html(oldfile)*/
			oldfile
	}
	Template.deadlineView.events({
		'click .handin': !->
			name = this.name
			Session.set 'homeworkname', name
		'click .score': !->
			name = this.name
			Session.set 'homeworkname', name
		'click .modify': (e)!->
			Session.set 'homeworkname', this.name
			a = document.createElement('input')
			a.type='datetime-local'
			a.name = 'dtmodify'
			b = document.createElement('button')
			b.type = 'submit'
			b.className = 'btmodify'
			b.innerText = 'commit'
			e.target.parentElement.appendChild(a)
			e.target.parentElement.appendChild(b)
			e.target.parentElement.removeChild(e.target)
		'click .btmodify': (e)!->
			name = Session.get 'homeworkname'
			newdate = e.target.parentElement.children[0].value
			day = newdate.split('T')[0].split('-')
			time = newdate.split('T')[1].split(':')
			mdate = new Date()
			mdate.setFullYear(day[0], day[1], day[2])
			mdate.setHours(time[0], time[1])
			mproject = Projects.find-one {name:name}
			Projects.update {_id:mproject._id} $set: deadline:mdate
			a = document.createElement('button')
			a.className = 'modify'
			a.innerText = 'modify'
			p = e.target.parentElement
			p.innerHTML = ''
			p.appendChild(a)
	})
	Template.upload.homeworkname = !->
		homeworkname = Session.get 'homeworkname'
		return homeworkname
	Template.score.homeworkname = !->
		homeworkname = Session.get 'homeworkname'
		return homeworkname
	Template.body.helpers ( {
		isAdmin : ->
			return Meteor.user() && Meteor.user().username == 'admin'
		}
	)
	Template.deadlineView.helpers ( {
		isNotAdmin : ->
			return !(Meteor.user() && Meteor.user().username == 'admin')
		}
	)
	Template.score.Allhandins = ->
		name = Session.get 'homeworkname'
		allhandins = Handins.find({'name':name}).fetch!
		if allhandins != []
			return allhandins
		else return 0
	Template.upload.helpers ( {
		show : ->
			d = 0
			homeworks = Projects.find!.fetch!
			for i from 0 to homeworks.length-1
				date-now = new Date
				if homeworks[i].deadline.valueOf! > date-now.valueOf!
					d++
			return d
		}
	)
	Template.score.events ( {
		'click .scorebt': (e)!->
			newscore = e.target.parentElement.children[0].value
			id = this._id
			Handins.update {_id:id} $set: score:newscore
		}
	)
	Accounts.ui.config({
		passwordSignupFields: "USERNAME_ONLY"
	})
