Template['homeworkList'].helpers {
  homeworkList: ->
    Homework.find {belong-to: Session.get 'selectedAssignmentId'}

  selectedHomework: ->
    Homework.find-one Session.get 'selectedHomeworkId'

  isAfterDeadline: ->
    unless Session.get 'selectedAssignmentId' then return false

    today = new Date!

    deadline-text = (Assignment.find-one Session.get 'selectedAssignmentId').deadline

    deadline = new Date(deadline-text)

    today > deadline
}

Template['homeworkList'].events {
  'change select.homeworkList': !->
    Session.set 'selectedHomeworkId', event.target.value

  'submit form.score': (ev, tpl)!->
    ev.prevent-default!

    homework-id = Session.get 'selectedHomeworkId'
    score = $ 'form.score input[name=point]' .val!
    Homework.update homework-id, {$set: {score}}

    $ 'form.score input[name=point]' .val ''
}