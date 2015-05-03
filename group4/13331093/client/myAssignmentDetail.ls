Template['myAssignmentDetail'].helpers {
    isvalid: ->
        b = new Date!
        assi = myassignment.findOne {"_id" : Session.get 'myassignmentId'}
        assi.deadline < b.toISOString!.replace("T"," ")
    notgrade: ->
        assi = myassignment.findOne {"_id" : Session.get 'myassignmentId'}
        if assi.status is '已提交' then true else false
    assignment: -> myassignment.findOne {"_id" : Session.get 'myassignmentId'}
    isteacher: -> Session.get('currentuser').identity is "teacher"
}

Template['myAssignmentDetail'].events {
    'submit .grade': (e)!->
        e.prevent-default!
        myassignment.update {_id: Session.get 'myassignmentId'}, {$set: {status: e.target.score.value}}
        $ '.myAssignmentDetail' .add-class 'hidden'
        $ '.submitAssignmentList' .remove-class 'hidden'
        $ '.assignment' .remove-class 'hidden'
}
