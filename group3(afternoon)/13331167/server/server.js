Meteor.startup(function() {
  if (Assignments.find().count() === 0) {
    Assignments.insert({
      assignmentName: "MyHomework",
      assignmentDeadline: "2015/05/18 22:00",
      assignmentContent: "MyHomework 是一个基于ExpressJS的Web 2.0应用，老师可以发布作业，学生可以提交作业。\r\n\r\n角色: 学生，老师。\r\n访问管理：\r\n只有选定了本课程老师和学生才能够访问使用本系统。\r\n老师可以看到所有的作业要求和所有学生提交的作业。\r\n学生能看到所有的作业要求，但只能够看到自己的作业。\r\n发布作业要求：老师可以发布作业要求，也可以修改一个已发布但是尚未截止的作业要求。\r\n提交作业：学生可以提交作业（可以多次提交作业，系统将保留最新的版本）。\r\ndeadline：老师可以设定/修改作业要求的截止时间，截止时间到达后，任何学生都将无法提交作业。\r\n作业评分: 截止时间到达之后，老师可以批改作业给出分数。\r\n"
    });
  }
  if (Meteor.users.find({username: 'admin'}).count() === 0) {
    Accounts.createUser({
      username: 'admin',
      password: '123456'
    });
  }
});

Meteor.methods({
  addHomework: function(studentName, content, assignmentId) {
    Homeworks.insert({
      studentName: studentName,
      content: content,
      owner: Meteor.userId(),
      assignmentId: assignmentId
    });
  },
  updateHomework: function(homeworkID, content) {
    Homeworks.update({_id: homeworkID}, { $set:{
      content: content
    }
      
    });
  },
  scoreHomework: function(homeworkID, score) {
    Homeworks.update({_id: homeworkID}, { $set:{
      score: score
    }
    });
  },
  addAssignment: function(assignmentName, assignmentContent, assignmentDeadline) {
    Assignments.insert({
      assignmentName: assignmentName,
      assignmentContent: assignmentContent,
      assignmentDeadline: assignmentDeadline
    });
  },
  uppdateAssignment: function(assignmentId, assignmentName, assignmentContent, assignmentDeadline) {
    Assignments.update({_id: assignmentId}, { $set:{
      assignmentName: assignmentName,
      assignmentContent: assignmentContent,
      assignmentDeadline: assignmentDeadline
    }
    });
  }
});