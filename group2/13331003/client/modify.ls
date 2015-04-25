Template['modify'].events {
  'submit form.modify': (ev, tpl)!->
    ev.prevent-default!

    title = $ '.modify input[name=title]' .val!
    deadline = $ '.modify input[name=deadline]' .val!
    content = $ '.modify textarea[name=content]' .val!

    $ '.modify input[name=title]' .val ''
    $ '.modify input[name=deadline]' .val ''
    $ '.modify textarea[name=content]' .val ''

    assignment-id = Session.get 'selectedAssignmentId'

    Assignment.update assignment-id, {$set: {title, deadline, content}}
}