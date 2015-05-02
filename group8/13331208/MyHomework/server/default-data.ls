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

requirement-one = "简介\nMyHomework 是一个基于ExpressJS的Web 2.0应用，老师可以发布作业，学生可以提交作业。\n\n
角色: 学生，老师。\n访问管理：\n只有选定了本课程老师和学生才能够访问使用本系
统。\n老师可以看到所有的作业要求和所有学生提交的作业。\n学生能看到所有的作业要求
，但只能够看到自己的作业。\n发布作业要求：老师可以发布作业要求，也可以修改一个已
发布但是尚未截止的作业要求。\n提交作业：学生可以提交作业（可以多次提交作业，系统
将保留最新的版本）。\ndeadline：老师可以设定/修改作业要求的截止时间，截止时间到
达后，任何学生都将无法提交作业。\n作业评分: 截止时间到达之后，老师可以批改作业给
出分数。\n提交制品\n应用源代码。\nREADME.md 说明如何运行应用。\n其它: 任何可能有
助于说明系统，帮助Reviewer评分的制品。\n评审标准:\n功能点实现（50%）：上述6个功
能点是否都正确实现。\n代码质量（40%）：代码是否符合TOP的原则。\n用户体验（10%）
：用户使用是否方便、直观、高效。"

requirement-two = "在Thinking Oriented Programming的思想指导下，改进自己Lab 04. Asynchronous JavaScript 的
作业。\n\n学习CoffeeScript或者LiveScript，重写作业，完成S1~S5。\n参考、学习Live
Coding Show代码，https://github.com/Thinking-Oriented-Programming/ring-menu ，思
考如何TOP。\n【选作】学习GruntJS，搭建自己的项目环境脚本，让开发工作流畅高效。\n
要点：在coding的过程中，除了思考当前程序的问题之外，还要观察和思考自己coding的方
式和过程，看看如何向TOP转变。\n\n交付件\n重写的作业：文件组织结构如Lab 04. Async
hronous JavaScript 提交要求。\n《TOP实践报告》：在根目录下用此文档说明自己在这次
TOP尝试中，所作的工作和体会，简明扼要，字数不限。\n评审标准\n正确性（50%）：S1~5
全部要求正确实现\n代码质量（30%）：可理解性、算法\nTOP（20%）：对TOP的理解和尝试
（评审者可查看《TOP实践报告》，对应代码，进行评审）\n注意：作业不能够抄袭，或者
简单变造Live Coding Show代码。大家要从Live Coding Show中学习的是思想、方法和过程
，然后自己尝试运用。"

homeworks =
  * homeworkName: 'hw0'
    requirement: requirement-one
    uploaded: 1
    startDate: Date.now!
    deadline: Date.now!+86400000*7
  * homeworkName: 'hw1'
    requirement: requirement-two
    uploaded: 1
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
