Homeworks = new Mongo.Collection("homeworks")
Submits = new Mongo.Collection("submits")

if (Meteor.isClient) {
  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });

//---------------------------------publish_homework--------------------------------------------
  Template.publish_homework.events({

    //老师发布作业,其中作业不可同名
    "submit form": function(event, template) {
      var title = event.target.title.value;
      var content = event.target.content.value;
      var deadline = event.target.deadline.value;
      var homeworks = Homeworks.find({}).fetch();
      var id = homeworks.length;
      if (Homeworks.findOne({title:title})) {
        alert("One homework has existed with title: "+title);
      } else {
        Homeworks.insert({
          id:id,
          title:title,
          content:content,
          deadline:deadline
        });
      }
      event.target.title.value = "";
      event.target.content.value = "";
      event.target.deadline.value = "";
      return false;
    },
    //控制显示发布作业的文本框
    "click .cancle": function(event, template) {
      $(".form-publish-homework").fadeOut(100);
    },
    "click .publish_homework": function(event, template) {
      $(".form-publish-homework").fadeIn(100);
    }
  });

  Template.publish_homework.helpers({
    //判断当前的用户是否为老师
    is_teacher: function() {
      return Meteor.user().username === 'teacher';
    }
  });
//---------------------------------------------------------------------------------------------


//-----------------------------------homework_block--------------------------------------------
  Template.homework_block.events({
    "submit .alter_content": function(event, template) {
      var content = event.target.content.value;
      var _id = event.target._id.value;

      //若超过截止时间，则无法修改作业要求
      var homework = Homeworks.findOne({_id:_id});
      var ddl = new Date(homework.deadline);
      var now = new Date();
      if (now.getTime() > ddl.getTime()) {
        alert("已经超过截止时间，无法修改作业要求！");
        return false;
      }
      Homeworks.update({
        _id: _id
      }, {
        $set: {
          content: content
        }
      }, {
        upsert: false
      });
      return false;
    },
    "submit .alter_deadline": function(event, template) {
      var _id = event.target._id.value;
      var deadline = event.target.deadline.value;
      var now = new Date();
      Homeworks.update({
        _id: _id
      }, {
        $set:{
          deadline:deadline
        }
      }, {
        upsert: false
      });
      return false;
    },
    "submit .form-submit-homework": function(event, template) {
      var id = event.target.id.value;
      var student = Meteor.user().username;
      var content = event.target.content.value;
      var title = event.target.title.value;

      //若超过截止时间，则无法提交作业
      var homework = Homeworks.findOne({id:parseInt(id)});
      var ddl = new Date(homework.deadline);
      var now = new Date();
      if (now.getTime() > ddl.getTime()) {
        alert("已经超过截止时间，无法提交！");
        return false;
      }
      submit = Submits.findOne({student:student, homework_id:id});
      if (submit) {
        //若已经提交过作业，则修改原有的作业
        Submits.update({
          _id:submit._id
        },{
          $set: {
            content:content
          }
        },{
          upsert:false
        });
      } else {
        Submits.insert({
          homework_id:id.toString(),
          student:student,
          content:content,
          title:title
        });
      }
      return false;
    },

    //控制作业文本框的显示
    "click .homework-cancle": function(event, template) {
      var id = event.target.id.replace("cancle","");
      $(".homework"+id).fadeOut(200);
    },
    "click .homework": function(event, template) {
      var id = event.target.id.replace("homework","");
      $(".homework"+id).fadeIn(200);
    },
  });


  Template.homework_block.helpers({

    //显示的作业按照homework的id升序显示
    homeworks: function() {
      return Homeworks.find({}, {sort: {id: 1}});
    },
    is_teacher: function() {
      return Meteor.user().username === 'teacher';
    }
  });
//---------------------------------------------------------------------------------------------

//-----------------------------------homework_submitting---------------------------------------
  Template.homework_submitting.helpers({

    //判断当前用户是否为学生
    is_student: function() {
      return Meteor.user().username !== 'teacher';
    },
    is_empty: function() {
      submits = Submits.find({student:Meteor.user().username}).fetch();
      return submits.length === 0;
    },

    //提交的作业按照homework的id升序显示
    submits: function() {
      return Submits.find({student:Meteor.user().username}, {sort:{homework_id:1}});
    }
  });
//---------------------------------------------------------------------------------------------

//-----------------------------------------hw_view---------------------------------------------
  Template.hw_view.events({
    "submit .hw_mark": function(event, template) {
      var id = event.target.id.value;
      var student = event.target.student.value;
      var score = event.target.score.value;

      var homework = Homeworks.findOne({id:parseInt(id)});
      var ddl = new Date(homework.deadline);
      var now = new Date();
      if (now.getTime() <= ddl.getTime()) {
        alert("未到截止时间，无法批改作业！");
        return false;
      }

      submit = Submits.findOne({homework_id:id.toString(), student:student});
      Submits.update({
        _id:submit._id
      },{
        $set: {
          score:score.toString()
        }
      },{
        upsert:false
      });
      return false;
    }
  });
  Template.hw_view.helpers({
    is_teacher: function() {
      return Meteor.user().username === 'teacher';
    },

    //提交的作业按照作业的id、学生姓名进行升序显示
    submits: function() {
      return Submits.find({}, {sort: {homework_id:1, student:2}});
    }
  });
}
//---------------------------------------------------------------------------------------------

if (Meteor.isServer) {
  Meteor.startup(function () {
    //创建老师用户
    teacher = {
      username: 'teacher',
      password: '123456',
    };
    if(!Meteor.users.findOne({username:'teacher'})){
      Accounts.createUser(teacher);
    }
  });
}
