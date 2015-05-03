Meteor.startup !-> console.log 'server startup'

# 服务端->客户端 数据
Meteor.publish 'status', ->
  return userstatus2.find!

Meteor.publish 'courses', ->
  return courses.find!

Meteor.publish 'usercourses', ->
  return usercourses.find!

Meteor.publish 'requirements', ->
  return requirements.find!

Meteor.publish 'homeworks', ->
  return homeworks.find!