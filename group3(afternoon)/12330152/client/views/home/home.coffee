Template.home.onRendered ()->
    utils.setView 'login' if not utils.getUser()

Template.home.helpers
    user: ()-> Session.get('myUser')
    isTeacher: ()-> Session.get('myUser').role == 'Teacher'
