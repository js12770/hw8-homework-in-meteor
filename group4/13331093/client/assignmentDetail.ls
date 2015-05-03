Template['assignmentDetail'].helpers {
    isvalid: ->
        b = new Date!
        assi = assignment.findOne {"_id" : Session.get 'assignmentId'}
        assi.deadline > b.toISOString!.replace("T"," ")
    assignment: -> assignment.findOne {"_id" : Session.get 'assignmentId'}
    isteacher: -> Session.get('currentuser').identity is "teacher"
}

Template['assignmentDetail'].events {
    'click .delete': (e)!->
        assignment.remove {_id: e.target.id}
        $ '.assignment' .remove-class 'hidden'
        $ '.assignmentdetail' .add-class 'hidden'

    'click .edit': (e)!->
        $ '.assignmentdetail' .add-class 'hidden'
        $ '.setassignment' .remove-class 'hidden'
        $ '#datetimepicker2' .datetimepicker!
        setTimeout "UE.getEditor('editor2');", 400
        assi =  assignment.findOne {_id : e.target.id}
        Session.set 'ispublish', false
        Session.set 'editassi', assi
        scri = "UE.getEditor('editor2').setContent(" + assi.content + ", true);"
        setTimeout scri, 500

    'click .submitbtn': (e)!->
        $ '.assignmentdetail' .add-class 'hidden'
        $ '.submitAssignment' .remove-class 'hidden'
        setTimeout "UE.getEditor('editor')", 500
        assi =  assignment.findOne {_id : e.target.id}
        Session.set 'submitassi', assi
        
}
