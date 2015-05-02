root = exports ? @
root.Users = new Mongo.Collection 'Users'
root.Homeworks = new Mongo.Collection 'Homeworks'
root.Answers = new Mongo.Collection 'Answers'
Meteor.methods {
  "publish-homework": (master, title, deadline, demand) ->
      Homeworks.insert homework = {master, title, deadline, demand}
  "hand-in-answer": (homeworkID, master, homeworkTitle, content, score) ->
      answer = Answers.findOne $and: [{master}, {homeworkID}]
      if answer
           Answers.update {_id : answer._id}, {$set: {content:content}}
      else
          Answers.insert answer = {homeworkID, master, homeworkTitle, content, score}
  "modify-homework": (homeworkID, newDeadline, newDemand) ->
      Homeworks.update {_id:homeworkID}, {$set:{
            deadline: newDeadline,
            demand: newDemand,}
      }
  "modify-answer": (answerID, newContent) ->
        Answers.update {_id : answerID}, {$set: {
            content:newContent,}
        }
  "score-answer": (answerID, getScore) ->
      Answers.update {_id : answerID}, {$set: {score:getScore}}
}
Router.route '/', ->
Meteor.startup ->