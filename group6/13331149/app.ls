root = exports ? @

root.Homeworks = new Mongo.Collection 'Homeworks'

Meteor.methods {
  # 函数名用的是字符串 
  'get-now-time': ->

}

Router.route '/', -> 
  if !Meteor.user! 
    if Meteor.loggingIn!
      this.render 'home'
    else
      Router.go 'login'

Router.route '/signup' -> this.render 'register'

Router.route '/login' -> 
  if !Meteor.user!
    if Meteor.loggingIn!
      this.render 'home'
    else
      this.render 'login'

Router.route '/logout' -> 
  Meteor.logout!
  Router.go '/'

Router.route '/homework' -> 
  this.render 'homework'

Router.route '/homework/publish' -> 
  this.render 'publish'

Router.route '/homework/showhw' -> 
  this.render 'showhw'

Router.route '/homework/showhw/:hwname' -> 
  this.render 'commandhw', {data: -> Homeworks.findOne {hwname: this.params.hwname}}

Router.route '/homework/scorehw' -> 
  this.render 'scorehw'

Router.route '/homework/correcthw/:hwname' -> 
  this.render 'correcthw', {data: {hwname: this.params.hwname}}

Router.route '/homework/modify/:hwname' ->
  this.render 'modify', {data: -> Homeworks.findOne {hwname: this.params.hwname}}

Router.route '/homework/uploadhw/:hwname' ->
  this.render 'uploadhw', {data: {hwname: this.params.hwname}}
