Meteor.subscribe 'status'

Template['deal_homework'].helpers {
  username: ->
    return Meteor.user!.username

  is-teacher: (username)->
    users = userstatus2.find {
      username: username
    } .fetch!
    for user in users
      if user.status == 'teacher'
        return true
      else
        return false

  is-student: (username)->
    users = userstatus2.find {
      username: username
    } .fetch!
    for user in users
      console.log user
      if user.status == 'student'
        return true
      else
        return false
}

Template['deal_homework'].events {
  'click #addHomework': (ev, tpl)->
    Session.set 'currentState', 'addHomework'

  'click #submitHomework': (ev, tpl)->
    Session.set 'currentState', 'submitHomework'
}