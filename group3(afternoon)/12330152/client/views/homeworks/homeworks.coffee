Template.homeworks.onRendered ()->
    utils.setView 'login' if not utils.getUser()

Template.homeworks.helpers
    homeworks: ()->
        homeworks = Template.instance().homeworks.get()
        homeworks.forEach (homework)->
            homework.pubDateStr = utils.formatDate homework.pubDate
            homework.deadlineStr = utils.formatDate homework.deadline, true
        return homeworks
    isTeacher: utils.isTeacher

Template.homeworks.onCreated ()->
    self = this
    self.homeworks = new ReactiveVar []
    Meteor.call 'getHomeworks', utils.methodHandler((res)->self.homeworks.set res.homeworks)

Template.homeworks.events
    'click .title>a': (evt)->
        _id = evt.target.getAttribute '_id'
        Session.set 'homework-id', _id
        utils.setView 'homework'
        return false
