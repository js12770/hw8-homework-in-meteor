Router.configure {
	layoutTemplate: 'layout'
}

Router.route '/', {name: 'login'}

Router.route '/home', {name: 'home'}

Router.route '/allhomework', {name: 'homeworkList'}

Router.route '/addassignment', {name: 'addAssignment'}

Router.route '/assignmentdetail/:_id', (eee) !->
	if Meteor.user().profile['identity'] is 'T'
		homew = Homeworks.find {targetAssignment: this.params._id}
		if homew.count! is 0
			homew = 0
		this.render 'homeworkDetail', {
			data: -> {
				Assignment: Assignments.findOne this.params._id
				Homework: homew
			}
		}
	else
		homew = Homeworks.find-one {author: Meteor.user().emails[0].address, targetAssignment: this.params._id}
		this.render 'homeworkDetail', {
			data: -> {
				Assignment: Assignments.findOne this.params._id
				Homework: homew
			}
		}

Router.route '/uploadhomework/:_id', {name: 'homeworkUpload', data: -> Assignments.findOne this.params._id}

Router.route '/article/:_id', (e) !->
	howk = Homeworks.findOne this.params._id
	assId = howk.targetAssignment
	assi = Assignments.findOne assId
	this.render 'article', {
		data: -> {
			Homework: howk
			Assignment: assi
		}
	}

requireLogin = (e)!->
	if !Meteor.user!
		alert('please login in first!');
		Router.go('/')
	else
		this.next();


Router.onBeforeAction(requireLogin, {only: 'home'});
Router.onBeforeAction(requireLogin, {only: 'homeworkList'});
Router.onBeforeAction(requireLogin, {only: 'addAssignment'});
Router.onBeforeAction(requireLogin, {only: 'article'});
Router.onBeforeAction(requireLogin, {only: 'homeworkDetail'});
Router.onBeforeAction(requireLogin, {only: 'homeworkUpload'});
