Template.assignments-list.helpers {
  assignments: ->
    Assignment.find!.fetch!
  have-assignments: ->
    Assignment.find!.fetch!.length > 0
}