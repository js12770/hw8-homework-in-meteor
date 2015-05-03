# 订阅服务端的数据
Meteor.subscribe 'status'
Meteor.subscribe 'courses'
Meteor.subscribe 'requirements'
Meteor.subscribe 'homeworks'

Template['my_view'].helpers {
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
      
  has-status: (username) ->
    users = userstatus2.find {
      username: username
    }
    console.log users
    if users.count! != 0
      return true
    else
      return false
  
  username: ->
    return Meteor.user!.username

  set-up-course: ->
    return (Session.get 'currentState') == 'setUpCourse'

  add-homework: ->
    return (Session.get 'currentState') == 'addHomework'

  submit-homework: ->
    return (Session.get 'currentState') == 'submitHomework'

  my-course: ->
    return (Session.get 'currentState') == 'myCourse'

  allrequirements: ->
    return requirements.find {
      coursename: (Session.get 'coursename')
    }

  myhomeworks: ->
    alls = []
    allrequirements = requirements.find { coursename: (Session.get 'coursename') } .fetch!
    allhomeworks = homeworks.find { coursename: (Session.get 'coursename') } .fetch!
    for requirement in allrequirements
      for homework in allhomeworks
        if homework.username is Meteor.user!.username and requirement.requirementname is homework.requirementname
          alls.push {
            teacher: requirement.username,
            student: homework.username,
            coursename: requirement.coursename,
            requirementname: requirement.requirementname,
            deadline: requirement.deadline,
            requirementcontent: requirement.requirementcontent,
            content: homework.content,
            score: homework.score
          }
    return alls

  all-requirements-homeworks: ->
    alls = []
    allrequirements = requirements.find { coursename: (Session.get 'coursename') } .fetch!
    allhomeworks = homeworks.find { coursename: (Session.get 'coursename') } .fetch!
    for requirement in allrequirements
      for homework in allhomeworks
        if requirement.requirementname is homework.requirementname
          alls.push {
            teacher: requirement.username,
            student: homework.username,
            coursename: requirement.coursename,
            requirementname: requirement.requirementname,
            deadline: requirement.deadline,
            requirementcontent: requirement.requirementcontent,
            content: homework.content,
            score: homework.score
          }
    return alls

  exceedTime: (deadline)->
    return (new Date(deadline) - Date.now!) > 0
}

Template['my_view'].events {
  'click .well': (ev, tpl)->
    console.log 'well clicked'
  
  'click #submitStatus': (ev, tpl)->
    ev.prevent-default!
    $ 'input[name=status]' .each !->
      if this.checked
        console.log this.value
        Meteor.call 'insertStatus', Meteor.user!.username, this.value

  'click #setUpCourse': (ev, tpl)->
    ev.prevent-default!
    Meteor.call 'setUpCourse', Meteor.user!.username, ($ '#courseName' .val!)
    Meteor.call 'joinCourse', Meteor.user!.username, ($ '#courseName' .val!)
    Session.set 'currentState', null

  'click #addHomeworkButton': (ev, tpl)->
    ev.prevent-default!
    coursename = $ 'input[name=coursename]' .val!
    requirementname = $ 'input[name=requirementname]' .val!
    deadline = $ 'input[name=deadline]' .val!
    requirementcontent = $ 'textarea[name=requirementcontent]' .val!
    Meteor.call 'addHomework', Meteor.user!.username, coursename, requirementname, deadline, requirementcontent 
    Session.set 'currentState', null

  'click #submitHomeworkButton': (ev, tpl)->
    ev.prevent-default!
    coursename = $ 'input[name=coursename]' .val!
    requirementname = $ 'input[name=requirementname]' .val!
    username = Meteor.user!.username
    content = $ 'textarea[name=content]' .val!
    Meteor.call 'submitHomework', username, coursename, requirementname, content
    Session.set 'currentState', null

  'click #updateRequirementContent': (ev, tpl)->
    ev.prevent-default!
    coursename = this.coursename
    requirementname = this.requirementname
    requirementcontent = $ ev.target .siblings 'textarea' .val!
    Meteor.call 'updateRequirementContent', coursename, requirementname, requirementcontent

  'click #submitScore': (ev, tpl)->
    ev.prevent-default!
    coursename = this.coursename
    requirementname = this.requirementname
    username = this.student
    score = $ ev.target .parent! .find '.score' .val!
    Meteor.call 'submitScore', coursename, requirementname, username, score
}