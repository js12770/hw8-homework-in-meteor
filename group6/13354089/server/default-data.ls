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

homeworks =
  * homeworkName: 'hw0'
    requirement: 'javascipt'
    uploaded: 0
    startDate: Date.now!
    deadline: Date.now!+86400000*7
  * homeworkName: 'hw1'
    requirement: 'python'
    uploaded: 0
    startDate: Date.now!
    deadline: Date.now!+86400000*7

load-homeworks = (homeworks)!->
  [load-homework homework for homework in homeworks]

load-homework = (homework)!->
  homework-already-exists = (typeof Homeworks.find-one homeworkName: homework.homeworkName) is 'object'
  if not homework-already-exists
    Homeworks.insert homework

submissions = 
  * homeworkName: 'hw0'
    student: 'student'
    uploadDate: Date.now!
    filename: 'hw0_student.zip'
    commitment: 'hard'
    grades: null
  * homeworkName: 'hw1'
    student: 'student'
    uploadDate: Date.now!
    filename: 'hw1_student.zip'
    commitment: 'hard'
    grades: 88
  * homeworkName: 'hw2'
    student: 'student'
    uploadDate: Date.now!
    filename: 'hw2_student.zip'
    commitment: 'hard'
    grades: null

load-submissions = (submissions)!->
  [load-submission submission for submission in submissions]

load-submission = (submission)!->
  submission-already-exists = (typeof Submissions.find-one homeworkName: submission.homeworkName) is 'object'
  if not submission-already-exists
    Submissions.insert submission

Meteor.startup ->
  load-users users
  load-homeworks homeworks
  load-submissions submissions
