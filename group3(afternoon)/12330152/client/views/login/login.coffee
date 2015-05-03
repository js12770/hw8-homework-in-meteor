Template.login.events
    'submit #loginForm': (evt)->
        form = evt.target
        username = form.username.value
        password = form.password.value
        Meteor.call 'myLogin', username, password, utils.methodHandler((res)->
            utils.setUser
                username: username
                role: res.role
            utils.setView 'home'
        )
        return false
