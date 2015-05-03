
fs = Npm.require "fs"
path = Npm.require "path"
Multer = Meteor.npmRequire "Multer"

uploadFile = ->
  temp_path = this.request.files.upfile.path
  target_dir = path.join (path.resolve '.'), '../../../../../public/files/'
  target_path = target_dir+this.request.files.upfile.name
  student = this.request.body.student
  homeworkName = this.request.body.homeworkName
  filename = this.request.files.upfile.name
  fs.rename temp_path, target_path, (error)!-> if error then console.log error else updateFileName student, homeworkName, filename
  this.response.writeHead 301, {'Location': '/home'}
  this.response.end!

updateFileName =  Meteor.bindEnvironment (student, homeworkName, filename)->
  submission = Submissions.find-one {student: student, homeworkName: homeworkName}
  Submissions.update {_id: submission._id}, {$set: {filename: filename}}, (error)-> if error then console.log error

if Meteor.is-server

  Accounts.on-create-user (options, user)->
    if not options.roles?
      user.roles = ['student']
    if options.profile?
      user.profile = options.profile
    Roles.add-users-to-roles user._id, user.roles if user.roles?.length > 0
    user

  Router.on-before-action Multer {
    dest:'../',
    rename: (fieldname, filename, req, res)-> req.body.homeworkName+'_'+req.body.student
  }

  Router.route '/submit/:hwid/:stuid', {
    name: 'submit',
    where: 'server',
    action: uploadFile,
  }
