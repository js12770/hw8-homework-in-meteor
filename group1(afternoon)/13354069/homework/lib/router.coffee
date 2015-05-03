Router.configure
	layoutTemplate: 'layout'
	waitOn: ->
    [ Meteor.subscribe("homeworks"), Meteor.subscribe("submits") ]

Router.route '/', name: 'homeworkList'

Router.route '/editHomeworkPage/:_id', {
	name: 'editHomeworkPage'
	data: -> Homeworks.findOne @params._id
}

Router.route '/new', name: 'createNew'

Router.route '/submits', name: 'submitsList'

Router.route '/editSubmitPage/:_id', {
	name: 'editSubmitPage'
	data: -> Submits.findOne @params._id
}

requireLogin = ->
  if not Meteor.user() then @render "accessDenied" else @next()

Router.onBeforeAction requireLogin
