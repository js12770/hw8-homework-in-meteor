Meteor.subscribe 'status'

Template['setup_course'].helpers {
  is-teacher: (username)->
    users = userstatus2.find {
      username: username
    } .fetch!
    console.log users
    for user in users
      console.log user
      if user.status == 'teacher'
        return true
      else
        return false

  username: ->
    return Meteor.user!.username
}

Template['setup_course'].events {
  'click #setUpCourse': (ev, tpl)->
    Session.set 'currentState', 'setUpCourse'
}