# Meteor.subscribe 'Homework'
# Meteor.subscribe 'Content'

Template.homework-list.helpers {
    homeworks: ->
        user = Meteor.user!
        if user.identity == 'teacher'
            return Homework.find {teacher-id: user._id}
        else
            return Homework.find!

    profile: ->
        return Meteor.user!.profile
}

Template.homework-page.helpers {
    homework: ->
        homeworkId = Session.get 'homeworkId'
        console.log homeworkId
        Homework.find-one {_id: homeworkId}

    profile: ->
        user = Meteor.user!
        return user.profile

    contents: ->
        homeworkId = Session.get 'homeworkId'
        console.log 'homework-id:'
        console.log homeworkId
        user = Meteor.user!
        if user.profile is 'teacher'
            return Content.find {homework-id: homeworkId}
        else
            console.log 'student'
            console.log homeworkId
            console.log Content.find-one {homework-id: homeworkId}
            return Content.find-one {homework-id: homeworkId, author: user._id}
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

Template.homework-page.events {
    'submit form#create-content': (e)->
        e.prevent-default!

        post = {
            content: $(e.target).find '[name=content]' .val!
        }

        homework-id = Session.get 'homeworkId'

        console.log homework-id

        user = Meteor.user!

        content = _.extend post, {
            author: user._id,
            submitted: new Date(),
            homework-id: homework-id,
            author-name: user.username
            score: 0
        }

        post._id = Content.insert content

        console.log post

        Router.go '/homework/' + homework-id

    'submit form#edit-homework': (e)->
        e.prevent-default!
    
        homework-id = Session.get 'homeworkId'

        post = {
            # user-id: Meteor.user!._id,
            title: $(e.target).find '[name=title]' .val!,
            demand: $(e.target).find '[name=demand]' .val!,
            deadline: $(e.target).find '[name=deadline]' .val!
        }

        Homework.update homework-id, {$set: post}, (error)->
            if error
                alert(error.reason)

    'click .delete': (e)->
        e.prevent-default!

        homework-id = Session.get 'homeworkId'

        if confirm "Delete this homework?"
            Homework.remove homework-id
            Router.go 'homeworkList'

}