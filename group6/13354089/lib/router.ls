Router.configure {
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
}

Router.route '/', name: 'welcome'

Router.route '/home', name: 'home'

Router.route '/info', name: 'info'

Router.route '/allhomeworks', name: 'allhomeworks'

getSubmissions = ->
  if Meteor.user! and 'teacher' in Meteor.user!.roles
    homeworks: Submissions.find {homeworkName: this.params.id} .fetch!
  else if Meteor.user! and 'student' in Meteor.user!.roles
    homeworks: Submissions.find {student: this.params.id} .fetch!
  else
    message: "No homeworks submit."

Router.route '/check/:id', name: 'check', data: getSubmissions

getOneHomework = ->
  if Meteor.user! and (('teacher' in Meteor.user!.roles and this.params.op is 'update') or ('student' in Meteor.user!.roles and this.params.op is 'submit'))
    homework = Homeworks.find-one {homeworkName: this.params.id}
    homework: homework, option: this.params.op
  else
    message: "Homework not exists.", option: 'notFound'

Router.route '/homework/:op/:id', name: 'submit-update', template: 'form', data: getOneHomework

Router.route '/create', name: 'create', template: 'form', data: {option: 'create'}

getOneSubmission = ->
  homework = Homeworks.find-one homeworkName: this.params.hwid
  submission = Submissions.find-one {homeworkName: this.params.hwid, student: this.params.stuid}
  submission.deadline = homework.deadline
  homework: submission

Router.route 'grade/:hwid/:stuid', name: 'grade', data: getOneSubmission

requireLogin = ->
  if not Meteor.user!
    Router.go 'welcome'
  else
    this.next()

Router.on-before-action requireLogin, {except: ['welcome', 'submit', 'download']}

requireExist = ->
  if not Meteor.user!
    Router.go 'welcome'
  else if 'student' in Meteor.user!.roles and Meteor.user!.username is this.params.id and (typeof Meteor.users.find-one username: this.params.id) is 'object'
    this.next()
  else if 'teacher' in Meteor.user!.roles and (typeof Homeworks.find-one homeworkName: this.params.id) is 'object'
    this.next()
  else
    Router.go 'home'

Router.on-before-action requireExist, {only: 'check'}
