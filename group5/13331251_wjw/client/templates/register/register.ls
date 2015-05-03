Template.register.events {
    'submit form': (e)!->
        e.prevent-default!

        post =
            username: $(e.target).find '[name=username]' .val()
            password: $(e.target).find '[name=password]' .val()
            profile: $(e.target).find '[name=profile]:checked' .val()

        console.log post

        Accounts.create-user post, (err)!->
            if (not err)
                Router.go('/')
}


