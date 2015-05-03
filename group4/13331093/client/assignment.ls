Template['assignment'].helpers {
    assignments: ->
        doc = assignment.find!.fetch!
        doc.sort (a,b) !->
          if a['status'] == b['status']
            return  a['deadline'] >= b['deadline']
          else
            return a['status'] > b['status']
        return doc
    isteacher: -> Session.get('currentuser').identity is "teacher"
}

Template['assignment'].events {
    'click .seedetail': (e)!->
        Session.set 'assignmentId', e.target.id
        $ '.assignment' .add-class 'hidden'
        $ '.submitAssignmentList' .add-class 'hidden'
        $ '.setassignment' .add-class 'hidden'
        $ '.assignmentdetail' .remove-class 'hidden'
}
