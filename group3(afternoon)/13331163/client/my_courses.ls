Meteor.subscribe 'usercourses'

Template['my_courses'].helpers {
  mycourses: ->
    return usercourses.find {
      username: Meteor.user!.username
    } .fetch!

  unique: (array)->
    res = []
    json = {}
    for val in array
      if !(json[val.coursename])
        res.push val
        json[val.coursename] = 1
    return res
}

Template['my_courses'].events {
  'click .mycourse': (ev, tpl)->
    Session.set 'currentState', 'myCourse'
    Session.set 'coursename', this.coursename
}