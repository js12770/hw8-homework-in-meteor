Meteor.subscribe 'courses'

Template['all_courses'].helpers {
  allcourses: ->
    return courses.find!.fetch!

  unique: (array)->
    res = []
    json = {}
    for val in array
      if !(json[val.coursename])
        res.push val
        json[val.coursename] = 1
    return res   
}

Template['all_courses'].events {
  'click .allcourse': (ev, tpl)->
    Meteor.call 'joinCourse', Meteor.user!.username, this.coursename
}