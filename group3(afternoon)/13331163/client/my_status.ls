Meteor.subscribe 'status'

Template['my_status'].helpers {
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

  is-teacher: (username)->
    users = userstatus2.find {
      username: username
    } .fetch!
    for user in users
      if user.status == 'teacher'
        return true
      else
        return false
        
  username: ->
    return Meteor.user!.username
}