Template.header.helpers
    user: utils.getUser

Template.header.events
    'click #logoutAnchor': ()->
        Meteor.call 'myLogout', utils.methodHandler(()->
            utils.setUser()
            utils.setView 'login'
        )
