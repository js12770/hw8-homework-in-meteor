Router.configure({
  layoutTemplate: 'main'
});

Router.route('/', {name: 'index'});

Router.route('/signup', {name: 'register'});

Router.route('/home', {name: 'home'});

Router.route('/homework', {name: 'homework'});

Router.route('/create', {name: 'create'});

Router.route('/upload', {name: 'upload'});

