root = exports ? @

root.userstatus2 = new Mongo.Collection('userstatus2')
root.courses = new Mongo.Collection('courses')
root.usercourses = new Mongo.Collection('usercourses')
root.requirements = new Mongo.Collection('requirements')
root.homeworks = new Mongo.Collection('homeworks')

Meteor.methods {
  insert-status: (username, status)->
    console.log username, ' 添加身份 ', status
    userstatus2.insert {
      username: username,
      status: status
    }

  set-up-course: (username, coursename)->
    console.log username, ' 创建课程 ', coursename
    courses.insert {
      username: username,
      coursename: coursename
    }

  join-course: (username, coursename)->
    console.log username, ' 加入课程 ', coursename
    usercourses.insert {
      username: username,
      coursename: coursename
    }

  add-homework: (username, coursename, requirementname, deadline, requirementcontent)->
    console.log username, coursename, requirementname, deadline, requirementcontent
    requirements.insert {
      username: username,
      coursename: coursename,
      requirementname: requirementname,
      deadline: deadline,
      requirementcontent: requirementcontent
    }

  submit-homework: (username, coursename, requirementname, content)->
    console.log "提交作业", username, coursename, requirementname, content
    homeworks.insert {
      username: username,
      coursename: coursename,
      requirementname: requirementname,
      content: content,
      score: null
    }

  update-requirement-content: (coursename, requirementname, requirementcontent)->
    console.log "更新作业要求", coursename, requirementname, requirementcontent
    requirements.update {
      coursename: coursename,
      requirementname: requirementname,
    }, {
      $set: {
        requirementcontent: requirementcontent
      }
    }, {
      multi: true
    }, (error, numberAffected, rawResponse)->
      return (console.log 'Error in update homework: ', error) if error
      console.log numberAffected

  submit-score: (coursename, requirementname, username, score)->
    console.log "提交分数", coursename, requirementname, username, score
    homeworks.update {
      coursename: coursename,
      requirementname: requirementname,
      username: username
    }, {
      $set: {
        score: score
      }
    }, {
      multi: true
    },  (error, numberAffected, rawResponse)->
      return (console.log 'Error in update homework: ', error) if error
      console.log numberAffected
}