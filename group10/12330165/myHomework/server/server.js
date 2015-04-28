/**
 * Created by Kira on 4/25/15.
 */
var Users = new Mongo.Collection("Students", {
    userID: String,
    userPassword: String,
    privilege: Number
});

var Homework = new Mongo.Collection("Homework", {
    title: String,
    deadline: String,
    content: String
});

var teacher = Users.findOne({userID: "teacher"});
if (!teacher) {
    Users.insert({
        userID: "teacher",
        userPassword: "teacher",
        privilege: 2
    });
}

Meteor.methods({
    checkLogin: function(userInfo) {
        var user = Users.findOne({userID: userInfo.userID, userPassword: userInfo.userPassword});
        return user;
    }
});

Meteor.methods({
    addUser: function(userInfo) {
        var user = Users.findOne({userID: userInfo.userID, userPassword: userInfo.userPassword});
        var type;
        if (!user) {
            Users.insert({
                userID: userInfo.userID,
                userPassword: userInfo.userPassword,
                privilege: 1
            });
            type = 1;
        } else {
            type = 0;
        }
        return type;
    }
});

Meteor.methods({
    addHomework: function(homework) {
        Homework.insert(homework);
        return 1;
    }
});

Meteor.methods({
    allhomework: function() {
        var homework = Homework.find({}).fetch();
        return homework;
    }
});