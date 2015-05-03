Router.configure {
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
}

requireLogin = ->
  if not Meteor.user!
    Router.go 'welcome'
  else
    this.next()

Router.on-before-action requireLogin, {except: ['welcome', 'submit', 'download']}

Router.route '/', name: 'welcome'

Router.route '/home', name: 'home'

Router.route '/info', name: 'info'

Router.route '/allhomeworks', name: 'allhomeworks'

require-authorized-and-exist = ->
  if not Meteor.user!
    Router.go 'welcome'
  else if 'student' in Meteor.user!.roles and Meteor.user!.username is this.params.id and (typeof Meteor.users.find-one username: this.params.id) is 'object'
    this.next!
  else if 'teacher' in Meteor.user!.roles and (typeof Homeworks.find-one homeworkName: this.params.id) is 'object'
    this.next!
  else
    Router.go 'home'

Router.on-before-action require-authorized-and-exist, {only: 'check'}

getSubmissions = ->
  if Meteor.user! and 'teacher' in Meteor.user!.roles
    homeworks: Submissions.find {homeworkName: this.params.id} .fetch!
  else if Meteor.user! and 'student' in Meteor.user!.roles
    homeworks: Submissions.find {student: this.params.id} .fetch!
  else
    message: "No homeworks submit."

Router.route '/check/:id', name: 'check', data: getSubmissions

getOneHomework = ->
  if not Meteor.user!
    message: "User not exists.", option: 'error-no-user'
  else if (('teacher' in Meteor.user!.roles and this.params.op is 'update') or ('student' in Meteor.user!.roles and this.params.op is 'submit'))
    homework = Homeworks.find-one {homeworkName: this.params.id}
    if (typeof homework) is 'object'
      homework: homework, option: this.params.op
    else
      message: "Homework not exists.", option: 'homework-not-found'
  else
    message: "User not authorized.", option: 'user-not-authorized'

Router.route '/homework/:op/:id', name: 'submit-update', template: 'form', data: getOneHomework

require-authorized = ->
  if not Meteor.user!
    Router.go 'welcome'
  else if 'teacher' in Meteor.user!.roles
    this.next!
  else
    Router.go 'home'

Router.on-before-action require-authorized, {only: ['create', 'grade']}

Router.route '/create', name: 'create', template: 'form', data: {option: 'create'}

getOneSubmission = ->
  homework = Homeworks.find-one homeworkName: this.params.hwid
  if (typeof Meteor.users.find-one username: this.params.stuid) is 'object' and (typeof homework) is 'object'
    submission = Submissions.find-one {homeworkName: this.params.hwid, student: this.params.stuid}
    submission.deadline = homework.deadline
    submission: submission
  else
    message: 'Student or Homework not exists.'

Router.route 'grade/:hwid/:stuid', name: 'grade', data: getOneSubmission

