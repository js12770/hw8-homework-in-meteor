Homeworks = new Mongo.Collection('homework');

Homeworks.allow({
  update: function(userId, post) { return true; },
  remove: function(userId, post) { return ownsDocument(userId, post); }
});

Homeworks.deny({
  update: function(userId, post, fieldNames) {
    return (_.without(fieldNames, 'deadline', 'title', 'description').length > 0);
  }
});

Homeworks.deny({
  update: function(userId, post, fieldNames, modifier) {
    var errors = validateHomework(modifier.$set);
    return errors.deadline || errors.description || errors.title;
  }
});

validateHomework = function(post) {
  var errors = {};
  if (!post.deadline) errors.deadline = "the deadline is needed";
  // else if (new Date(post.deadline) < new Date()) errors.deadline = "the deadline should be late than now";
  if (!post.description) errors.description = "the description is needed";
  if (!post.title) errors.title = "the title is needed";
  return errors;
}

Meteor.methods({
  homeworkInsert: function(postAttributes) {
    check(Meteor.userId(), String);
    check(postAttributes, {
      deadline: String,
      description: String,
      title: String
    });

    var errors = validateHomework(postAttributes);
    if (errors.deadline||errors.description || errors.title) throw new Meteor.Error('invalid-post', "you have give your post a deadline, a title and a description");

    var user = Meteor.user();
    var post = _.extend(postAttributes, {
      userId: user._id, 
      author: user.username, 
      submitted: new Date(),
      answers: []
    });
    var postId = Homeworks.insert(post);
    return {
      _id: postId
    };
  },
  answerInsert: function(answerAttributes, homeworkId) {
    check(Meteor.userId(), String);
    check(answerAttributes, {body: String} );
    check(homeworkId, String);

    var user = Meteor.user();
    var post = _.extend(answerAttributes, {
      userId: user._id, 
      author: user.username, 
      submitted: new Date(),
    });

    Homeworks.update(homeworkId, {$pull: {answers: {userId: user._id}}});
    Homeworks.update(homeworkId, {$push: {answers: post}}, function(error) {
      if (error) {
        alert(error.reason);
      }
    });
    return;
  },
  scoreUpdate: function(homeworkId, userId, score) {
    Homeworks.update({ _id: homeworkId, answers: { $elemMatch: {userId: userId} } }, { $set: {"answers.$.score": score} }, function(error) {
        if (error) alert(error.reason);
        else return;
      });
  }
});
