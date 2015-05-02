Template['publish'].events {
  'submit form.publish': (ev, tpl)!->
    ev.prevent-default!

    title = $ '.publish input[name=title]' .val!
    deadline = $ '.publish input[name=deadline]' .val!
    content = $ '.publish textarea[name=content]' .val!
    publish-by = Meteor.user!.username

    $ '.publish input[name=title]' .val ''
    $ '.publish input[name=deadline]' .val ''
    $ '.publish textarea[name=content]' .val ''

    Assignment.insert {title, deadline, content, publish-by}
}