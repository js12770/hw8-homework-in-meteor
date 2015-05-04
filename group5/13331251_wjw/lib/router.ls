Router.configure {
    layoutTemplate: 'main',
    loadingTemplate: 'loading',
    waitOn: ->
        Meteor.subscribe 'Homework'
        Meteor.subscribe 'Content'
}

Router.route '/', {name: 'homeworkList'}

Router.route '/register', {name: 'register'}

Router.route '/homework/:id', ->
    Session.set 'homeworkId', this.params.id
    console.log(Session.get 'homeworkId')
    this.render 'homework-page'

Router.route '/content/:id', ->
    Session.set 'contentId', this.params.id
    this.render 'content-page'

require-login = !->
    console.log 'hehe'
    if not Meteor.user-id()
        this.render 'login'
        console.log 'hehe'
    else
        this.next!

Router.on-before-action require-login, {only: 'homeworkList', 'content-page', 'homework-page'}