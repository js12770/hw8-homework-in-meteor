Homeworks = new Meteor.Collection('homeworks');
Submits = new Meteor.Collection('submits');

Router.configure({
  layoutTemplate: 'layout'
});
Router.route('/', function() {
  this.render('index');
});
Router.route('/sub/:id', function() {
  if (Meteor.userId()) {
    this.render('sub');
  } else {
  	this.redirect('/');
  }
});
