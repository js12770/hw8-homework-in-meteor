Meteor.methods {
  string-to-date: (str)->
    nd = new Date str 
  date-to-string: (date)->
    date.to-date-string!
}
if Meteor.isClient
  Template.assign.rendered = !->
    console.log ($ '.datepicker')
    $ '.datepicker' .pickadate {
      selectMonths: true
      selectYears: 15
    }
  Template.assign.helpers {
    toNiceString: (dt)-> dt.toDateString!
  }
  
  Template.detail.rendered = !->
    $ 'ul.tabs' .tabs!
    console.log new Date!

  Template.detail.events {
    'change #upload': (event, template) !->
      files = event.target.files
      for file in files
        new-file = new FS.File file
        new-file.metadata =
          requirementId: $ '[name=requirement]' .val!
          studentName: Meteor.user!.profile.name
          score: -1

        FilesFS.insert new-file, (err, file-obj) !->
          if err then console.log err
          else console.log 'seccesss'
    'change .scoreform': (e) !->
      $tg = $ e.target .parent!.parent!
      hwid = $tg.find '[name=homeworkid]' .val!
      score = +$tg.find '[name=getscore]' .val!
      FilesFS.update hwid, {$set: {'metadata.score': score}}, (err)!->
        console.log err
    }

  AccountsTemplates.addField {
    _id: 'name'
    type: 'text'
    displayName: "Name"
    required: true
    errStr: 'Invalid Name!'
  }
  AccountsTemplates.addField {
    _id: 'Identity'
    type: 'radio'
    displayName: "Identity"
    select: 
      * text: "Teacher"
        value: "1"
      * text: "Student"
        value: "0"
    required: true
    errStr: 'Invalid idnetitys!'
  }

  Template.signup.rendered = !->
    $ 'label' .each !->
      input = $ @ .prev!
      $(@).attr 'for', $(input).attr('id')

  Template.layout.helpers {
    identityIs: (identity) ->
      Meteor.user!.profile['Identity'] is identity
  }

  Template.detail.helpers {
    scoreValid: ->
      true
      #Meteor.user!.profile['Identity'] is "1" and @deadline < new Date!
    submitValid: ->
      Meteor.user!.profile['Identity'] is "0" and @deadline > new Date!
    toNiceString: (dt)-> dt.toDateString!
    getHwList: -> FilesFS.find {'metadata.requirementId': @alias}
    gaveScore: (score) -> score>=0?

  }

  Template.assign.events {
    'submit form': (e) !->
      e.prevent-default!
      ddl = $ e.target .find '#deadline' .val!
      requirement =
        title: $ e.target .find '#title' .val!
        alias: $ e.target .find '#alias' .val!
        deadline: new Date ddl
        description: $ e.target .find '#description' .val!

      old-require = Requirements.find-one {'alias': requirement.alias}
      if old-require
        requirement._id = Requirements.update {'_id': old-require._id}, requirement, {upsert: true}
      else
        requirement._id = Requirements.insert requirement
      Router.go "/requirement/#{requirement.alias}"
  }

  Template.list.helpers {
    turnToNextRow: (idx)-> idx%3 is 0
    endCard: (idx)-> idx is @requireList.count!-1
  }
