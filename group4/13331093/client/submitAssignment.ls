Template['submitAssignment'].helpers {
    ispublish: -> Session.get('ispublish') is true
    assignment: -> Session.get 'submitassi'
}

Template['submitAssignment'].events {
    'submit .submitassiment': (e)!->
        e.prevent-default!
        record = myassignment.findOne {title : Session.get('submitassi').title, username: Session.get('currentuser').firstName}
        if record
            cont = UE.getEditor 'editor' .getContent!
            myassignment.update {_id : record._id}, {$set: {content: cont}}
            #myassignment.where {title : Session.get('submitassi').title, username: Session.get('currentuser').firstName} .update { content: UE.getEditor('editor').getContent! }
        else
            myassign =
                username: Session.get('currentuser').firstName
                content: UE.getEditor 'editor' .getContent!
                assignmentid: Session.get 'assignmentId'
                deadline: Session.get('submitassi').deadline
                title: Session.get('submitassi').title
                status: '已提交'
            myassignment.insert myassign
        $ '.submitAssignment' .add-class 'hidden'
        $ '.submitAssignmentList' .remove-class 'hidden'
        $ '.assignment' .remove-class 'hidden'
}
