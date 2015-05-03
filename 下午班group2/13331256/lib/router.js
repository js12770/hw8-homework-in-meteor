Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'notFound',
  waitOn: function() { return Meteor.subscribe('homeworks'); }
});

Router.route('/', {name: 'homeworksList'});

Router.route('/homework/:_id', {
  name: 'homeworkPage',
  data: function() { return Homeworks.findOne(this.params._id); }
});

Router.route('/homework/:_id/edit', {
  name: 'homeworkEdit',
  data: function() { return Homeworks.findOne(this.params._id); }
});

Router.route('/submit', {name: 'homeworkSubmit'});

var requireLogin = function () {
  if (!Meteor.user()) {
    if (Meteor.loggingIn()) {
      this.render(this.loadingTemplate);
    } else {
      this.render('accessDenied');
    } 
  } else {
      this.next();
  }
}

Router.onBeforeAction(requireLogin);
Router.onBeforeAction('dataNotFound', {only: 'homeworkPage'});