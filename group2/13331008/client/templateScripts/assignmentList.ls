Template['assignmentList'].helpers {
  assignmentList: ->
    Assignment.find!

  selectedAssignment: ->
    Assignment.find-one Session.get 'selectedAssignmentId'

  isAfterDeadline: ->
    unless Session.get 'selectedAssignmentId' then return false

    today = new Date!

    deadline-text = (Assignment.find-one Session.get 'selectedAssignmentId').deadline

    deadline = new Date(deadline-text)

    today > deadline

  isTeacher: ->
    (Meteor.user!.username.index-of 'admin') isnt -1
}

Template['assignmentList'].events {
  'click .dropdown .menu .item': !->
    Session.set 'selectedAssignmentId', ($ event.target .attr 'data-value')
    $ '.ui.dropdown.homeworkList .text' .text 'Homework' .add-class 'default'
    Session.set 'selectedHomeworkId', void

  'click .publish-button': !-> Router.go '/publish'

  'click .modify-button': !-> Router.go '/modify'

  'click .submit-button': !-> Router.go '/submit'
}

Template['assignmentList'].on-rendered !->
  $ 'select.dropdown' .dropdown!
  if Session.get 'selectedAssignmentId'
    title = $ '#assignmentList input[name=title]' .val!

    $ '#assignmentList .ui.dropdown.assignmentList .text'
    .remove-class 'default' .text title

