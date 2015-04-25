Template.main.events {
    'click .logout': (e)!->
        Meteor.logout!
        Router.go '/'
}
