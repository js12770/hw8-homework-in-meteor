getDatetimeValue = (date)->
    tmp = date.toISOString()
    return tmp.substr(0, tmp.length - 8)

Template.homework.helpers
    homework: ()->
        homework = Template.instance().homework.get()
        homework.pubDateStr = utils.formatDate homework.pubDate
        homework.deadlineStr = utils.formatDate homework.deadline, true
        homework.deadlineVal = getDatetimeValue homework.deadline
        homework.outOfDeadline = homework.deadline < new Date
        return homework
    isTeacher: utils.isTeacher

Template.homework.onCreated ()->
    self = Template.instance()
    self.homework = new ReactiveVar null, (a, b)->
        return true if (not a) and (not b)
        return false if not (a and b)
        return a.title == b.title and a.details == b.details and a.deadline == b.deadline
    id = Session.get 'homework-id'
    Meteor.call 'getHomework', id, utils.methodHandler((res)->
        homework = res.homework
        self.homework.set homework
    )

Template.homework.events
    'submit #submit-form': (evt)->
        form = evt.target
        solution = form.solution.value
        id = Session.get 'homework-id'
        Meteor.call 'submit', id, solution, utils.methodHandler(()->alert 'ok')
        return false
    'submit #homework-form': (evt)->
        id = Session.get 'homework-id'
        form = evt.target
        title = form.title.value
        details = form.details.value
        deadline = new Date form.deadline.value
        self = Template.instance()
        Meteor.call 'modifyHomework', id, title, details, deadline, utils.methodHandler((res)->
            alert 'ok'
            self.homework.set res.homework
        )
        return false
    'submit .grade-form': (evt)->
        id = Session.get 'homework-id'
        form = evt.target
        username = form.getAttribute 'username'
        score = form.score.value
        Meteor.call 'grade', id, username, score, utils.methodHandler(()->alert 'ok')
        return false
