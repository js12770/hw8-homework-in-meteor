Template['grouping_buttons'].helpers {
  students-amount: -> Students.find!count!
}

students-amount = null
groups-amount = null
rearrange-index = -1
get-group = (index)->
  students-in-a-group = Math.floor students-amount / groups-amount
  group-index = Math.floor index / students-in-a-group
  if group-index < groups-amount then group-index else ++rearrange-index

Template['grouping_buttons'].events {
  'click .clear-all-student': !-> if confirm 'Clear all students?' then
    Meteor.call 'remove-all-students'

  'click .grouping': !-> 
    groups-amount := parse-int ($ 'input.groups-amout' .val!)
    if groups-amount < 1
      alert 'Group amount must great than 1'
    else
      students = Students.find!fetch!
      students.sort -> if 4 * Math.random! > 2 then true else false # shuffle
      students-amount := students.length
      [Students.update {_id: student._id}, $set: group: (get-group index) for student, index in students]

}