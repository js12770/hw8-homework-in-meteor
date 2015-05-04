Router.configure {
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
}

Router.route '/assign', name: 'assign'
Router.route '/modify/:alias', !->
  @render 'assign', {
    data: -> Requirements.find-one {alias: @params.alias}
  }
Router.route '/signin', name: 'signin'
Router.route '/signup', name: 'signup'
Router.route '/', !->
  @render 'list', {
    data: -> {requireList: Requirements.find!.map (value, index)->
      value.index = index
      value
    }
  }
Router.route '/requirement/:alias', !->
  @render 'detail', {
    data: -> Requirements.find-one {alias: @params.alias}
  }

Router.route '/signout', !->
  Meteor.logout !->
    Router.go '/signin'


requireLogin = !->
  if not Meteor.user! then @render 'signin'
  else @next!

Router.onBeforeAction requireLogin, except: ['signin', 'signup']

root = exports ? this
root.Router = Router