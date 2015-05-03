Template.postSubmit.events({
  'submit form': function(e) {
    e.preventDefault();

    var hw = {
      deadline  : req.param('deadline'),
      time      : req.param('time'),
      homework  : req.param('homework'),
      course    : req.param('course'),
      detail    : req.param('detail'),
      author    : req.param('author')
    };

    Homework.insert(homework);
    Router.go('/home');
  }
});