# Meteor.subscribe 'Homework'
# Meteor.subscribe 'Content'

Template.content-page.helpers {
    author: ->
        content-id = Session.get 'contentId'
        content = Content.find-one {_id: content-id}
        author-id = content.author-id
        return Meteor.users.find-one {_id: author-id}.username

    content: ->
        content-id = Session.get 'contentId'
        content = Content.find-one {_id: content-id}
        return content

    profile: ->
        return Meteor.user!.profile

    can: ->
        now-date = new Date()
        content-id = Session.get 'contentId'
        content = Content.find-one {_id: content-id}
        homework = Homework.find-one {_id: content.homework-id}
        deadline = homework.deadline.split "-"
        endDate = new Date(deadline[0], deadline[1], deadline[2])
        return Date.parse(now-date) -  Date.parse(endDate) >= 0
}

Template.content-page.events {
    'submit form#edit': (e)->
        e.prevent-default!

        content-id = Session.get 'contentId'

        post = {
            content : $(e.target).find '[name=content]' .val!
        }

        Content.update content-id, {$set: post}, (error)->
            if error
                alert(error.reason)


    'submit form#enscore': (e)->
        e.prevent-default!

        content-id = Session.get 'contentId'

        post =
            score: $(e.target).find '[name=score]' .val!

        Content.update content-id, {$set: post}, (error)->
            if error
                alert(error.reason)

}