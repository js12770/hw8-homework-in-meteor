Template['assignment'].helpers {
  assignment_list: -> Assignments.find {teacherId: Meteor.userId!}, {sort: {deadline: -1}}
  changeTimeFormat: (time)-> time.replace 'T', ' ' 
}

Template['assignment'].events {
  'click .delete': (e)!-> Meteor.call 'delete-assignment', e.target.id
  
  'click .edit': (e)!->
    Session.set 'assignmentId' e.target.id
    $ '.edit-assignment' .remove-class 'hidden'
    $ '.publish-assignment, .assignment-table' .add-class 'hidden'
  
  'click .revise': (e)!->
    Session.set 'assignmentId' e.target.id
    $ '.revise-assignment' .remove-class 'hidden'
    $ '.publish-assignment, .edit-assignment, .assignment-table' .add-class 'hidden'
}
