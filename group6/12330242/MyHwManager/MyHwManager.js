Tasks = new Mongo.Collection("tasks");
Dead = new Mongo.Collection("Dead");

var hw = new FS.Collection("hw", {
  stores: [new FS.Store.FileSystem("hw", {
    path: "~/uploads"
  })]
});

if (Meteor.isClient) {
  // Template.dlTemplate.helpers({
  // 	deadl: function() {
  // 		// alert(deadLine.find({}));
  // 		// console.log(tojson(deadLine.find({})));
  // 		return deadLine.find({});
  // 	}
  // });
  Template.task.helpers({

    //
    // isOwner: function() {
    //     return this.owner === Meteor.userId();
    // }
  });


  Template.body.helpers({
    tasks: function() {
      if (Meteor.user().username === "admin")
        return Tasks.find({
          username: {
            $ne: "default"
          }
        });
      else
      // return Tasks.findOne(Meteor.userId());
        return Tasks.find({
        username: Meteor.user().username
      });
    },

    isTeacher: function() {
      return Meteor.user().username === "admin";
    },

    init: function() {
      // alert("flag");
      console.log(Tasks.find().count());
      if (Tasks.find().count() === 0) {
        console.log("create collection");
        Tasks.insert({
          username: "default",
          createdAt: "Yes",
          owner: "default",
          score: "No information ",
          deadLine: "No information",
          hwReq: "No information",
          hwR: "No information"
        });
      }
    },
    getNum:function() {
      return Tasks.find({username:"default"});
    },
  });

  Template.body.events({
    //upload homework
    'change .upload': function(event, template) {
      FS.Utility.eachFile(event, function(file) {
        hw.insert(file, function(err, fileObj) {});
      });
      // console.log(Tasks.find({username : Meteor.user().username}).fetch().length)
      if (Tasks.find({
          username: Meteor.user().username
        }).fetch().length === 0) {
        Tasks.insert({
          username: Meteor.user().username,
          createdAt: "Yes",
          owner: Meteor.userId(),
          score: "No information",
          deadLine: "No information",
          hwReq: "No information",
          hwR: "No information"
        });
      }
    },

    'submit .new-deadline': function(event) {
      var text = event.target.text.value;
      Meteor.call("updateDl", text);

      event.target.text.value = "";
      return false;
    },

    'submit .new-require': function(event) {
      var text = event.target.text.value;
      Meteor.call("updateR", text);

      event.target.text.value = "";
      return false;
    },
    'submit .new-score': function(event) {
      var text = event.target.text.value;
      var textArray = text.split('|');
      var _username = textArray[0];
      var _score = textArray[1];
      Meteor.call("updatesocre", _username, _score);

      event.target.text.value = "";
      return false;
    }
  });

  Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
}

Meteor.methods({
  //updateThe deadLine
  updateDl: function(text) {
    Tasks.update({}, {
      $set: {
        deadLine: text
      }
    }, {
      multi: true
    }, function(err, numaff, rawNum) {
      if (err)
        console.log(err);
    });
  },

  updateR: function(text) {
    Tasks.update({}, {
      $set: {
        hwR: text
      }
    }, {
      multi: true
    }, function(err, numaff, rawNum) {
      if (err)
        console.log(err);
    });
  },
  updatesocre: function(_username, _score) {
    Tasks.update({
      username: _username
    }, {
      $set: {
        score: _score
      }
    });
  }

  // updateHw: function(taskId) {
  //   Tasks.update(taskId, {
  //     $set: {
  //       createdAt: new Date()
  //     }},
  //     {
  //       multi: true
  //     },
  //     function(err, numAff, rawNum) {
  //       if (err)
  //         console.log(err);
  //
  //       console.log(numAff);
  //       console.log(rawNum);
  //     });
  // }

})
