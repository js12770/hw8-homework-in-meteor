Template['submit'].events {
  'submit form.submit': (ev, tpl)!->
    ev.prevent-default!

    title = $ '.submit input[name=title]' .val!
    content = $ '.submit textarea[name=content]' .val!
    belong-to = Session.get 'selectedAssignmentId'
    submit-by = Meteor.user!.username

    $ '.submit input[name=title]' .val ''
    $ '.submit textarea[name=content]' .val ''

    if Homework.find-one {belong-to, submit-by}
      homework-id = (Homework.find-one {belong-to, submit-by})._id
      Homework.update homework-id, {$set: {title, content}}
    else
      Homework.insert {title, content, belong-to, submit-by}

    if not (Session.get 'selectedHomeworkId')
      homework-id = $ 'select.homeworkList' .val!
      Session.set 'selectedHomeworkId', homework-id
}