Template.modify-assignment.events {
  'submit form': (e)->
    e.preventDefault!

    description = ($ e.target) .find '[name=description]' .val!
    deadline = ($ e.target) .find '[name=deadline]' .val! .replace 'T', ' '
    requirement = ($ e.target) .find '[name=requirement]' .val!

    path = window.location.pathname.split '/'
    url = path[2]

    assignment = Assignment.find-one {url: url}

    Assignment.update assignment._id, {$set: {description: description, deadline: deadline, requirement: requirement}}
    Router.go '/assignments/' + url
}