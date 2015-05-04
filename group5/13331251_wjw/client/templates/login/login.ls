Template.login.events {
    'submit form': (e)!->
        e.prevent-default!

        username = ($ e.target).find '[name=username]' .val()
        password = ($ e.target).find '[name=password]' .val()

        Meteor.login-with-password username, password, (err)!->
            if (err)
                alert('Error username or password!')
            else
                Router.go '/'
    'click #register': (e)!->
        Router.go '/register'
}
