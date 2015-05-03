
Template.registerHelper("isTeacher", function() {
    return Meteor.user().username == "WangQing";
  }
);

Template.publishAssignment.events({
  "submit form": function (event, template) {
    var title = event.target.title.value;
    var content = event.target.content.value;
    var ddl = event.target.deadline.value;
    var _ddl = new Date(ddl.slice(0, 10) + " " + ddl.slice(11, 16));
    Assignments.insert({
      title     : title,
      content   : content,
      createdAt : new Date(),
      createdAtx: format(new Date()),
      ddl       : new Date(_ddl),
      ddlx      : format(_ddl)
    });
    bootbox.alert("作业成功发布！");
    event.target.title.value = "";
    event.target.content.value = "";
    event.target.deadline.value = "";
    return false;
  },
});

Template.showAssignments.helpers({
  assignments: function() {
    return Assignments.find();
  }
});

Template.showAssignments.events({
  "click .card": function (event, template) {
    template.$('.assignment'+this._id).toggleClass("hide");
  }
});

Template.uploadAnswer.events({
  "submit form": function (event, template) {
    var id = event.target.hw_id.value;
    var title = event.target.title.value;
    var answer = event.target.answer.value;
    var current = new Date();
    var ddl = Assignments.find({_id: id}).fetch()[0].ddl;
    if (current > ddl) {
      bootbox.alert("作业已经截止");
      return false;
    } else {
      Submittals.update({
        _id         : this._id
      },{
        username    : Meteor.user().username,
        hw_id       : id,
        title       : title,
        answer      : answer,
        submittedAt : current,
        submittedAtx: format(current),
        grade       : "未评分"
      },{
        upsert      : true
      });
      event.target.answer.value = "";
      bootbox.alert("作业提交成功！");
      return false;
    }
  }
});

Template.uploadContent.events({
  "submit form": function (event, template) {
    var content = event.target.content.value;
    var current = new Date();
    var ddl = this.ddl;
    if (current > ddl) {
      bootbox.alert("截止时间已到，请勿修改题目内容");
      return false;
    } else {
      Assignments.update({
        _id : this._id
      },{
        $set: {content: content}
      });
      event.target.content.value = "";
      bootbox.alert("内容修改成功！");
      return false;
    }
  },
});

Template.uploadDdl.events({
  "submit form": function (event, template) {
    var ddl = event.target.deadline.value;
    var _ddl = new Date(ddl.slice(0, 10) + " " + ddl.slice(11, 16));
    Assignments.update({
      _id : this._id
    },{
      $set: {ddl: _ddl, ddlx: format(_ddl)}
    });
    bootbox.alert("时间修改为：" + format(_ddl));
    event.target.deadline.value = "";
    return false;
  },
});

Template.uploadedAssignments.helpers({
  submittals: function() {
    return Submittals.find({username: Meteor.user().username});
  },
  submittalsx: function() {
    return Submittals.find({});
  }
});

Template.uploadedAssignments.events({
  "submit form": function (event, template) {
    var grade = event.target.grade.value;
    if (isNaN(grade)) {
      bootbox.alert("请输入数字");
      event.target.grade.value = "";
      return false;
    }
    var current = new Date();
    var ddl = Assignments.find({_id: this.hw_id}).fetch()[0].ddl;
    if (current < ddl) {
      bootbox.alert("截止时间尚未到达，并不能改分");
      return false;
    } else {
      Submittals.update({
        _id : this._id
      },{
        $set: {grade: grade}
      })
      event.target.grade.value = "";
      bootbox.alert("打分成功！");
      return false;
    }
  },
  "click .card": function (event, template) {
    template.$('.submission'+this._id).toggleClass("hide");
  }
});

/*auxiliary functions*/
format = function(date) {
  year = exp(date.getFullYear());
  month = exp(date.getMonth() + 1);
  day = exp(date.getDate());
  hour = exp(date.getHours());
  minute = exp(date.getMinutes());
  return year+"/"+month+"/"+day+" "+hour+":"+minute+":00";
}

exp = function(date) {
  var str = date.toString();
  if (str.length < 2)
    str = "0" + str;
  return str;
}