Template.register.events {
    'submit form': (e)!->
        e.prevent-default!

        post =
            username: $(e.target).find '[name=username]' .val()
            password: $(e.target).find '[name=password]' .val()
            identity: $(e.target).find '[name=identity]' .val()

        Accounts.create-user post, (err)!->
            if (not err)
                Router.go('/')
}
