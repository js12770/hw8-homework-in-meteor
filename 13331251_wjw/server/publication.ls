Meteor.publish 'Homeworks', -> Homework.find!

Meteor.publish 'Contents', -> Content.find!

Accounts.on-create-user (options, user)->
    if (options.identity)
        user.identity = options.identity