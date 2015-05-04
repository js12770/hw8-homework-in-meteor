Template['homeworkList'].helpers {
  homeworkList: ->
    belong-to = Session.get 'selectedAssignmentId'

    if (Meteor.user!.username.index-of 'admin') isnt -1
      Homework.find {belong-to}
    else
      submit-by = Meteor.user!.username
      Homework.find {belong-to, submit-by}

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
  'click .dropdown .menu .item': !->
    Session.set 'selectedHomeworkId', ($ event.target .attr 'data-value')

  'submit form.score': (ev, tpl)!->
    ev.prevent-default!

    homework-id = Session.get 'selectedHomeworkId'
    score = $ 'form.score input[name=point]' .val!
    Homework.update homework-id, {$set: {score}}

    $ 'form.score input[name=point]' .val ''
}

Template['homeworkList'].on-rendered !->
  $ 'select.dropdown' .dropdown!

  if Session.get 'selectedHomeworkId'
    title = $ '#homeworkList input[name=title]' .val!

    $ '#homeworkList .ui.dropdown.homeworkList .text'
    .remove-class 'default' .text title