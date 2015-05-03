Iron.utils.debug = true;

Router.route('/', function () {
  this.layout('layout');
  this.render('Home');
});

Router.route('/user', function () {
  this.layout('layout');
  this.render('User');
});

Router.route('/submit', function () {
  this.layout('layout');
  this.render('Submit');
});
 
Router.route('/new_assignment', function () {
  if (Meteor.user() && Meteor.user().username === 'admin') {
    this.layout('layout');
    this.render('New_assignment');
  } else {
    return 'unauthorized';
  }
});

Router.route('/assignment', function () {
  if (Meteor.user()) {
    this.layout('layout');
    if (Meteor.user().username === 'admin') {
      this.render('Teacher');
    } else {
      this.render('Student');
    }
  } else {
    return 'unauthorized';
  }
  
});

Router.route('/homework/update', function () {
  this.layout('layout');
  this.render('Student_update');
  // if (Meteor.user().username === 'admin') {
  //   this.render('Teacher');
  // } else {
  //   this.render('Student', {data: _id});
  // }
});

Router.route('/assignment/update', function () {
  this.layout('layout');
  this.render('Update_assignment');
  // if (Meteor.user().username === 'admin') {
  //   this.render('Teacher');
  // } else {
  //   this.render('Student', {data: _id});
  // }
});

// Router.route('/assignment/:_id', {
//   name: 'student',
//   data: function() { return Assignments.findOne(this.params._id); }
// });

Router.onBeforeAction(function () {
  if (!Meteor.userId()) {
    this.next();
    this.redirect('/');
  } else {
    this.next();
  }
});