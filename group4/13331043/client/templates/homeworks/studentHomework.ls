get-date-time = ->
  now = new Date!
  year = now.get-full-year!
  month = if now.get-month! + 1 > 10 then now.get-month! else '0' + (now.get-month! + 1)
  day = if now.get-date! > 10 then now.get-date! else '0' + now.get-date!
  hour = if now.get-hours! > 10 then now.get-hours! else '0' + now.get-hours!
  minute = if now.get-minutes! > 10 then now.get-minutes! else '0' + now.get-minutes!
  year + '-' + month + '-' + day + ' ' + hour + ':' + minute

Template.student-homework.events {
  'submit form#first': (e)->
    e.preventDefault!

    path = window.location.pathname.split '/'
    url = path[2]

    homework = {
      content: ($ e.target) .find '[name=content]' .val!
      time: get-date-time!
      grade: undefined
      author-id: Meteor.userId!
      author-username: Meteor.user!.username
      author-name: Meteor.user!.profile.name
      assignment-url: url
    }
    Homework.insert homework, (error, id) ->
      if error
        alert error.reason
      else
        Router.go '/assignments/' + url

  'submit form#again': (e)->
    e.preventDefault!

    id = ($ e.target) .find '[name=_id]' .val!
    content = ($ e.target) .find '[name=content]' .val!
    time = get-date-time!

    Homework.update id, {$set: {content: content, time: time}}
}