Meteor.methods {
  update-homework: (selector, modifier, callback)->
    Homeworks.update selector, modifier, callback
}
/*setBody: ->
    Iron.Router.bodyParser.urlencoded {extended: false}
  setFile: ->
    Multer {dest:'../', rename: (filename)-> 'miao'+filename}
    
*//*setFileName =  Meteor.bindEnvironment (student, homework, filename)->
    Submissions.update {student: student, homeworkName: homework}, {$set: {filename: filename}}
    (error)-> if error then console.log error*/
if Meteor.is-server
  Accounts.on-create-user (options, user)->
    console.log options
    if not options.roles?
      user.roles = ['student']
    if options.profile?
      user.profile = options.profile
    Roles.add-users-to-roles user._id, user.roles if user.roles?.length > 0
    user
  Multer = Meteor.npmRequire "Multer"
  Router.on-before-action Multer {dest:'../', rename: (fieldname, filename, req, res)-> req.body.name+'_'+req.body.student}
  /*Router.on-before-action Iron.Router.bodyParser.urlencoded {extended: false}
  Router.onBeforeAction(Multer({dest:'../', rename: function(filename){return 'miao'+filename}}))
Multer = Meteor.npmRequire "Multer"*/
  getFile = ->
    Multer {dest:'../', rename: (fieldname, filename, req, res)-> 'miao'+filename/*req.params.hwid+'_'+req.params.stuid*/}

  setFileName =  Meteor.bindEnvironment (students, homeworks, filenames)->
    console.log 'in'
    hw = Submissions.find-one {student: students, homeworkName: homeworks}
    console.log hw
    Submissions.update {_id: hw._id}, {$set: {filename: filenames}}, (error)-> if error then console.log error
  setFile = ->
    /*console.log this
    console.log this.request*/
    console.log this.request.files
    fs = Npm.require("fs");
    path = Npm.require("path");
    console.log target_dir = path.join (path.resolve '.'), '../web.browser/app/files/'
    temp_path = this.request.files.upfile.path
    target_path = target_dir+this.request.files.upfile.name
    target_path_save = path.join (path.resolve '.'), '../../../../../public/files/'+this.request.files.upfile.name
    console.log target_path_save+'\n'+temp_path
    console.log students = this.request.body.student
    console.log homeworks = this.request.body.name
    console.log filenames = this.request.files.upfile.name
    fs.rename temp_path, target_path_save, (error)!-> if error then console.log error else setFileName students, homeworks, filenames
    console.log 'ssssssssssss'
    fs.rename temp_path, target_path, (error)!-> if error then console.log error
    this.response.writeHead 301, {'Location': '/home'}
    this.response.end!
    /*if file-msg? and file-msg
      console.log 'pupu'
      setFileName student, homework, filename
    else
      console.log 'wuwuwu'*/
  /*
  Router.on-before-action Multer {dest:'../', rename: (filename)-> 'miao'+filename}, only: 'submit'
  */

  Router.route '/submit/:hwid/:stuid', {
    name: 'submit',
    where: 'server',
    action: setFile,
  }

  getOne = ->
    console.log this.params.hwid, this.params.stuid
    fs = Npm.require "fs"
    path = Npm.require "path"
    filename = this.params.hwid+'_'+this.params.stuid+'.zip'
    this.response.writeHead 200, {'Content-Type': 'application/octet-stream', 'Content-Disposition': "attachment; filename="+filename}
    filePath = path.join (path.resolve '.'), '../../../../../public/files/'+filename
    console.log fs.readFileSync filePath
    this.response.end fs.readFileSync filePath

  Router.route '/download/:hwid/:stuid', {
    name: 'download',
    where: 'server',
    /*action: ->
      console.log this.params.hwid, this.params.stuid
      fs = Npm.require "fs"
      path = Npm.require "path"
      url = 'miao.zip'
      this.response.writeHead 200, {'Content-Type': 'application/octet-stream', 'Content-Disposition': "attachment; filename="+url}
      filePath = path.join (path.resolve '.'), '../web.browser/app/files/miao.zip'
      this.response.end fs.readFileSync filePath*/
    action: getOne
  }

