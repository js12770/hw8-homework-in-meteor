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
}

Template['assignmentList'].events {
  'change select.assignmentList': !->
    Session.set 'selectedAssignmentId', event.target.value
}