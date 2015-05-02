var Homeworks = new Mongo.Collection("homeworks");
var Users = new Mongo.Collection("users");
var Requests = new Mongo.Collection("requests");
var Files = new FS.Collection("files", {
  stores : [new FS.Store.FileSystem("files", {path: "upload"})]
});

if (Meteor.isClient) {
  Template.body.helpers({
    submit : function() {
      return Session.get('submit');
    },
    request : function() {
      return Session.get('request');
    },
    homework : function() {
      return Session.get('homework');
    },
    register : function() {
      return Session.get('register');
    },
    user : function() {
      return Session.get('user');
    },
    homeworks : function() {
      if(Session.get('user').role === 'teacher') {
        return Homeworks.find({});
      }
      else if(Session.get('user').role === 'student'){
        return Homeworks.find({uid : Session.get('user')._id});
      }
    },
    teacher : function() {
      return Session.get('user').role === 'teacher';
    },
    student : function() {
      return Session.get('user').role === 'student';
    },
    requests : function() {
      return Requests.find({});
    },
    requestContent : function() {
      return Session.get('requestContent');
    },
    updateRequest : function() {
      return Session.get('updateRequest');
    },
    canChange : function() {
      return !Session.get('canChange');
    },
    homeContent : function() {
      return Session.get('homeContent');
    },
    check : function() {
      return Session.get('check');
    },
    schecked : function() {
      return Session.get('schecked');
    },
    timeout : function() {
      return Session.get('timeout');
    }
  });

  Template.body.events({
    "click .submit" : function(event) {
      Session.set('submit',true);
      Session.set('request',false);
      Session.set('homework',false);
    },
    "click .request" : function(event) {
      Session.set('request',true);
      Session.set('submit',false);
      Session.set('homework',false);
    },
    "click .homework" : function(event) {
      Session.set('homework',true);
      Session.set('submit',false);
      Session.set('request',false);
    },
    "submit .register" : function(event) {
      var user = Users.findOne({username : event.target['username'].value});
      if(!!user) {
        alert("用户名已经存在!")
        return false;
      }
      var username = event.target['username'].value;
      var password = event.target['password'].value;

      var Reg = /^[a-zA-Z0-9]+$/;
      if(!Reg.test(username)) {
        alert('账号名称不符合要求!');
        return false;
      }
      else if(!Reg.test(password)) {
        alert('密码不符合要求!');
        return false;
      }
      Users.insert({
        username : username,
        password : password,
        role : event.target['role'].value
      });
      Session.set('register',false);
      alert("注册成功!");
      return false;
    },
    "submit .login" : function(event) {
      var user = Users.findOne({username : event.target['username'].value,password : event.target['password'].value});
      if(!!user) {
        Session.setAuth('user',user);
      }
      else {
        alert("用户名或者密码错误!");
      }
      return false;
    },
    "submit .submitHomework" : function(event) {
      var files = event.target['homework'].files;
      var rid = event.target['request'].value;
      if(rid === '') {
        alert('作业类型不能为空!')
        return false;
      }
      if(files.length === 0) {
        alert('请选择要提交的作业!');
        return false;
      }
      var request = Requests.findOne({_id : rid});
      var deadline = request.deadline;
      var today = new Date();
      var year = today.getFullYear();
      var month = today.getMonth() + 1;
      if(month < 10) {
        month = '0' + month;
      }
      var day = today.getDate();
      if(day < 10) {
        day = '0' + day;
      }
      var time = year + '-' + month + '-' + day;
      if(time > deadline) {
        alert("已经过了作业提交的deadline!");
        return false;
      }

      for (var i = 0, ln = files.length; i < ln; i++) {
        Files.insert(files[i], function (err, fileObj) {
          if(!!Homeworks.findOne({filename:fileObj.name()}))
            alert('作业已经存在，更新作业成功!');
          else {
            alert('提交作业成功!');
          }
          Meteor.call('updateHomework',fileObj.name(),rid,Session.get('user')._id);
        });
      }
      return false;
    },
    "submit .createRequest" : function(event) {
      var title = event.target['title'].value;
      title = title.replace(/(^\s*)|(\s*$)/g,"");
      var content = event.target['content'].value;
      content = content.replace(/(^\s*)|(\s*$)/g,"");
      var deadline = event.target['deadline'].value;
      if(deadline === '' || title === '' || content === '') {
        alert('请将信息填写完整!');
        return false;
      }
      Requests.insert({
        title : title,
        deadline : deadline,
        content : content,
        uid : Session.get('user')._id
      })
      alert('创建成功!');
      return false;
    },
    "click #logup" : function(event) {
      Session.set('register',true);
      return false;
    },
    "click #login" : function(event) {
      Session.set('register',false);
      return false;
    },
    "click #logout" : function(event) {
      Session.setAuth('user',null);
    },
    "click #requestView" : function(event) {
      var id = event.target.value;
      var request = Requests.findOne({_id : id});
      request.content = request.content.replace(/\x20/g,'&nbsp').replace(/\n/g,'<br />');
      Session.set('requestContent',request);
      var deadline = Session.get('requestContent').deadline;
      var today = new Date();
      var year = today.getFullYear();
      var month = today.getMonth() + 1;
      if(month < 10) {
        month = '0' + month;
      }
      var day = today.getDate();
      if(day < 10) {
        day = '0' + day;
      }
      var time = year + '-' + month + '-' + day;
      if(time > deadline) {
        Session.set('timeout',true);
      }
      else {
        Session.set('timeout',false);
      }
      if(time > deadline || Session.get('user').role === 'student') {
        Session.set('canChange',false);
      }
      else {
        Session.set('canChange',true);
      }
      $('#myModal').modal();
      Session.set('updateRequest',false);
      $('#content').html(request.content);
    },
    "click #change" : function(event) {
      request = Session.get('requestContent');
      request.content = request.content.replace(/&nbsp/g,' ').replace(/<br \/>/g,'\n');
      Session.set('requestContent',request);
      Session.set('updateRequest',true);
    },
    "click #check" : function(event) {
      Session.set('hid',event.target.value);
      var homework = Homeworks.findOne({_id : event.target.value});
      var rid = homework.rid;
      var request = Requests.findOne({_id : rid});
      var deadline = request.deadline;
      var today = new Date();
      var year = today.getFullYear();
      var month = today.getMonth() + 1;
      if(month < 10) {
        month = '0' + month;
      }
      var day = today.getDate();
      if(day < 10) {
        day = '0' + day;
      }
      var time = year + '-' + month + '-' + day;
      if(time > deadline) {
        Session.set('timeout',true);
      }
      else {
        Session.set('timeout',false);
      }
      Session.set('check',true);
      $('#checkModal').modal();
    },
    "click #look" : function(event) {
      Session.set('check',false);
      var homework = Homeworks.findOne({_id : event.target.value});
      homework.comment = homework.comment.replace(/\x20/g,'&nbsp').replace(/\n/g,'<br />');
      Session.set('homeContent',homework);
      if(Session.get('homeContent').checked === true) {
        Session.set('schecked',true);
      }
      else {
        Session.set('schecked',false);
      }
      $('#checkModal').modal();
      $('#comment').html(homework.comment);
    },
    "submit .updateRequest" : function(event) {
      var title = event.target['title'].value;
      var content = event.target['content'].value;
      var deadline = event.target['deadline'].value;
      Requests.update(Session.get('requestContent')._id,{$set:{
        title : title,
        content : content,
        deadline : deadline
      }});
      alert('修改成功!');
      return false;
    },
    "submit .checkHomework" : function(event) {
      var score = event.target['score'].value;
      var comment = event.target['comment'].value;
      var checkuid = Session.get('user')._id;
      Homeworks.update(Session.get('hid'),{$set:{
        score : score,
        comment : comment,
        checkuid : checkuid,
        checked : true
      }});
      alert("评分成功!");
      return false;
    }
  });
}

Meteor.methods({
  updateHomework : function(filename,rid,uid) {
    Homeworks.update({filename : filename},{
      filename : filename,
      time : new Date(),
      uid : uid,
      score : 0,
      comment : '',
      checkuid : '',
      rid : rid,
      check : false
    },{upsert : true});
  }
});