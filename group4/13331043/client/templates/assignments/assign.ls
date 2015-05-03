Template.assign.events {
  'submit form': (e)->
    e.preventDefault!

    assignment = {
      title: ($ e.target) .find '[name=title]' .val!
      description: ($ e.target) .find '[name=description]' .val!
      url: ($ e.target) .find '[name=url]' .val!
      deadline: ($ e.target) .find '[name=deadline]' .val! .replace 'T', ' '
      requirement: ($ e.target) .find '[name=requirement]' .val!
      author: Meteor.user!._id
      author-name: Meteor.user!.profile.name
    }

    if Assignment.find-one {url: assignment.url} then
      return alert "already exists the same url!"
    else
      Assignment.insert assignment, (error, id) ->
        if error
          alert error.reason
        else
          Router.go '/assignments/' + assignment.url
}