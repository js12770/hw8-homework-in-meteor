Template['body'].helpers {
    currentuser: -> Session.get 'currentuser'
    isteacher: -> Session.get('currentuser').identity is "teacher"
}

Template['body'].events {
    'click .back': !->
        $ ".submitAssignmentList" .remove-class 'hidden'
        $ ".home" .remove-class 'hidden'
        $ ".assignment" .remove-class 'hidden'
        $ ".assignmentdetail" .add-class 'hidden'
        $ ".myAssignmentDetail" .add-class 'hidden'
        $ ".setassignment" .add-class 'hidden'
        $ ".submitAssignment" .add-class 'hidden'
}
