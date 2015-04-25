Template['myhomework'].helpers {
    homeworks1: ->
      homeworks1 = []
      homeworks = Homework.find!fetch!
      for homework in homeworks
        if (Date.parse homework.ddl) > (Date.parse Date!)
          homeworks1.push homework
      homeworks1

    homeworks2: ->
      homeworks2 = []
      homeworks = Homework.find!fetch!
      for homework in homeworks
        if (Date.parse homework.ddl) < (Date.parse Date!)
          homeworks2.push homework
      homeworks2
      
    myhomeworks: ->
      myhomeworks = Studenthomework.find!fetch!
      myhomeworks
}

Template['myhomework'].events {
  'click .showhandin':(event, template)  !->
    myhomework = Studenthomework.find-one {student:Meteor.user! .username, hwid:this._id}
    if myhomework
      $ event.target .parent! .parent! .next! .find '.answer' .html myhomework.answer 
    $ event.target .parent! .parent! .next! .slideToggle!
    $ event.target .parent! .parent! .next! .next! .slideToggle!

  'click .handin': (ev, tpl)-> 
    ev.prevent-default!
    hwid = this._id
    student = Meteor.user! .username
    answer = ($ event.target .parent! .parent! .find 'textarea[name=answer]').val!
    myhomework = Studenthomework.find-one {student:Meteor.user! .username, hwid:this._id}
    score = '-'
    if myhomework
      Studenthomework.update {_id:myhomework._id}, {$set:{answer: answer}}
    else
      Studenthomework.insert myhomework = {hwid, student, answer, score}
    $ event.target .parent! .parent! .parent! .prev! .find '.answer' .html answer 

  'click .detail': (ev, tpl)-> 
    ev.prevent-default!
    myhomework = Studenthomework.find-one {student:Meteor.user! .username, hwid:this._id}
    if myhomework
      $ event.target .parent! .parent! .next! .find '.answer' .html myhomework.answer 
      $ event.target .parent! .parent! .next! .find '.score' .html myhomework.score
    $ event.target .parent! .parent! .next! .slideToggle!
}