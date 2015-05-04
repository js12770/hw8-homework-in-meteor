users =
  * email: 'teacher@test.com'
    username: 'teacher'
    password: 'teacher'
    profile: {firstName: 'teacher', lastName: 'teacher'}
    roles: ['teacher']
  * email: 'student@test.com'
    username: 'student'
    password: 'student'
    profile: {firstName: 'student', lastName: 'student'}
    roles: ['student']

load-users = (users)!-> [load-user user for user in users]

load-user = (user)!->
  user-already-exists = (typeof Meteor.users.find-one username: user.username) is 'object'
  if not user-already-exists
    id = Accounts.create-user user
    Roles.add-users-to-roles id, user.roles if user.roles?.length > 0


Meteor.startup ->
  load-users users
