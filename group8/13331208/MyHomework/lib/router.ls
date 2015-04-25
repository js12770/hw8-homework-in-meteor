Router.configure {
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
}

Router.route '/', name: 'welcome'

Router.route '/home', name: 'home'

requireLogin = ->
  if not Meteor.user!
    Router.go 'welcome'
  else
    this.next()

Router.on-before-action requireLogin, {except: 'welcome'}

