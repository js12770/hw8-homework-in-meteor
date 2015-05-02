get-date-time = ->
  now = new Date!
  year = now.get-full-year!
  month = if now.get-month! + 1 > 10 then now.get-month! else '0' + (now.get-month! + 1)
  day = if now.get-date! > 10 then now.get-date! else '0' + now.get-date!
  hour = if now.get-hours! > 10 then now.get-hours! else '0' + now.get-hours!
  minute = if now.get-minutes! > 10 then now.get-minutes! else '0' + now.get-minutes!
  year + '-' + month + '-' + day + ' ' + hour + ':' + minute

Router.configure {
  layout-template: 'layout',
  loading-template: 'loading',
  not-found-template: 'not_found',
  wait-on: ->
    Meteor.subscribe 'Assignment'
    Meteor.subscribe 'Homework'
}

Router.route '/', {name: 'index'}
Router.route '/signin', {name: 'signin'}
Router.route '/signup', {name: 'signup'}
Router.route '/signout', !->
  Meteor.logout (error) !->
    Router.go '/signin', {name: 'signin'}

Router.route '/assign', {name: 'assign'}
Router.route '/assignments', {name: 'assignmentsList'}
Router.route '/assignments/:url', {
  name: 'assignmentPage',
  data: ->
    obj = new Object!
    obj.assignment = Assignment.find-one {url: @params.url}
    obj.homework = Homework.find-one {author-id: Meteor.user-id!, assignment-url: @params.url}
    if obj.assignment then obj.overtime = if obj.assignment.deadline < get-date-time! then true else false
    obj
}

Router.route '/assignments/:url/homeworks', {
  name: 'homeworksList',
  data: ->
    obj = new Object!
    assignment = Assignment.find-one {url: @params.url}
    obj.homeworks = Homework.find {assignment-url: @params.url} .fetch!
    obj.have-homeworks = Homework.find {assignment-url: @params.url} .fetch! .length > 0
    if assignment then obj.overtime = if assignment.deadline < get-date-time! then true else false
    obj
}

Router.route '/assignments/:url/modify', {name: 'modifyAssignment'}

require-login = !->
  if !Meteor.user! then
    if Meteor.loggingIn! then
      @render @loading-template
  else
    @next!

Router.on-before-action require-login, {except: ['signin', 'signup']}

root = exports ? @
root.Router = Router