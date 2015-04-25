Router.configure({
  layoutTemplate: 'main'
});

Router.route('/', {name: 'index'});

Router.route('/signup', {name: 'register'});

Router.route('/home', {name: 'home'});

Router.route('/login', {name: 'index'});
