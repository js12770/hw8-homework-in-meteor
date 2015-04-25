Template.homework-list.helpers {
    homeworks: ->
        user = Meteor.user!
        if user.identity == 'teacher'
            return Homework.find {teacher-id: user._id}
        else
            return Homework.find!
}

Template.homework-page.helpers {
}

Template.homework-list.events {
    "submit form": (e)->
        e.prevent-default!

        post = {
            title: $(e.target).find '[name=title]' .val!
            demand: $(e.target).find '[name=demand]' .val!
            deadline: $(e.target).find '[name=deadline]' .val!
        }

        post._id = Homework.insert post
}

