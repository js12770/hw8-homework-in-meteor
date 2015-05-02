Template['modify'].helpers {
  selectedAssignment: ->
    Assignment.find-one Session.get 'selectedAssignmentId'
}

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

    $ '.homepage-button' .click!

  'click .homepage-button': !-> Router.go '/'

  'click .modify-button': !-> Router.go '/'
}