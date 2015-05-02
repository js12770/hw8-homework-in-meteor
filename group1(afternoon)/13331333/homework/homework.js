Questions = new Mongo.Collection("questions")
Answers = new Mongo.Collection("answers")

if (Meteor.isClient) {
    Template.publish.events({
        'submit form': function(ev, tpl) {
            var title = ev.target.title.value;
            var requirements = ev.target.requirements.value;
            var deadline = ev.target.deadline.value;
            Questions.insert({
                title: title,
                requirements: requirements,
                deadline: deadline
            });
            ev.target.title.value = '';
            ev.target.requirements.value = '';
            ev.target.deadline.value = '';
            return false;
        }
    });

    Template.show_question.helpers({
        questions: function() {
            questions = Questions.find();
            return questions;
        }
    });

    Template.update.events({
        'submit form': function(ev, tpl) {
            var requirements = ev.target.content.value;
            var deadline = ev.target.deadline_update.value;
            ev.target.content.value = '';
            ev.target.deadline_update.value = '';
            question = Questions.findOne({_id: this._id});
            if (isDeadlinePassed(question.deadline)) {
                alert('The deadline has passed!');
                return false;
            }
            if (requirements != '')
                Questions.update(question._id, {$set: {requirements:requirements}});
            if (deadline != '')
                Questions.update(question._id, {$set: {deadline:deadline}});
            return false;
        }
    });

    Template.answer.helpers({
        answer: function() {
            answer = Answers.findOne({question_id: this._id, student_id: Meteor.userId()});
            return answer;
        }
    });

    Template.answer.events({
        'submit form': function(ev, tpl) {
            var content = ev.target.answer.value;
            ev.target.answer.value = '';
            question = Questions.findOne({_id: this._id});
            if (isDeadlinePassed(question.deadline)) {
                alert('The deadline has passed!');
                return false;
            }
            answer = Answers.findOne({question_id: this._id, student_id: Meteor.userId()});
            if (answer)
                Answers.update(answer._id, {$set: {content: content}});
            else
                Answers.insert({
                    content: content,
                    student_id: Meteor.userId(),
                    question_id: this._id,
                    student_name: Meteor.user().username,
                    score: null
                });
            return false;
        }
    });

    Template.score.helpers({
        answers: function() {
            var answers = [];
            var question = Questions.findOne({_id: this._id});
            if (question)
                answers = Answers.find({question_id: question._id});
            return answers;
        }
    })

    Template.score.events({
        'submit form': function(ev, tpl) {
            var score = ev.target.score.value;
            var student_id = ev.target.student_id.value;
            var question_id = ev.target.question_id.value;
            ev.target.score.value = '';
            question = Questions.findOne({_id: question_id});
            if (!isDeadlinePassed(question.deadline)) {
                alert("The deadline hasn't passed!");
                return false;
            }
            answer = Answers.findOne({question_id: question_id, student_id: student_id});
            if (answer)
                Answers.update(answer._id, {$set: {score: score}});
            return false;
        }
    });
    Accounts.ui.config({
        passwordSignupFields: "USERNAME_ONLY"
    });

    Template.registerHelper('isteacher', function() {
        return (Meteor.user().username === 'teacher');
    });

    Template.registerHelper('islogin', function() {
        return Meteor.user();
    });
}

isDeadlinePassed = function(deadline) {
    var dead_time = new Date(deadline);
    dead_time.setHours(dead_time.getHours()-8);
    return dead_time < new Date();
}