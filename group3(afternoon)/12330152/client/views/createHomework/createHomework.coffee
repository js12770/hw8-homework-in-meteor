Template.createHomework.onRendered = ()->
    utils.setView 'login' if not utils.getUser()
    utils.setView 'home' if not utils.isTeacher()

Template.createHomework.events
    'submit #createHomework-form': (evt)->
        form = evt.target
        title = form.title.value
        details = form.details.value
        deadline = new Date form.deadline.value
        Meteor.call 'createHomework', title, details, deadline, utils.methodHandler(()->utils.setView 'homeworks')
        return false
