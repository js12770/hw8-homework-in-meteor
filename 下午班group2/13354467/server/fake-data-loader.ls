users =
  * email: 'admin@test.com'
    username: 'admin'
    password: 'supersecret'
    roles: ['admin', 'user']
  * email: 'user@test.com'
    username: 'user'
    password: 'password'
    roles: ['user']

load-users = (users)!-> [load-user user for user in users]

load-user = (user)!->
  user-already-exists = (typeof Meteor.users.find-one username: user.username) is 'object'
  if not user-already-exists
    id = Accounts.create-user user 
    Roles.add-users-to-roles id, user.roles if user.roles?.length > 0

Meteor.startup ->
  load-users users
