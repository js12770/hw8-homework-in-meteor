if Meteor.is-server
  Accounts.on-create-user (options, user)->
    console.log options
    if not options.roles?
      user.roles = ['student']
    Roles.add-users-to-roles user._id, user.roles if user.roles?.length > 0
    user
