Template.signup.events
    'submit #signupForm': (evt)->
        form = evt.target
        username = form.username.value
        password = form.password.value
        role = form.role.value
        Meteor.call 'myRegister', username, password, role, utils.methodHandler(()->
            utils.setUser
                username: username
                role: role
            utils.setView 'home'
        )
        return false
