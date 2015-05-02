Template['form'].helpers {
  user: -> Meteor.user!
  userIsTeacher: -> if Meteor.user! and 'teacher' in Meteor.user!.roles then true else false
  userIsStudent: -> if Meteor.user! and 'student' in Meteor.user!.roles then true else false
  optionIsCreate: (option)-> option is 'create'
  optionIsUpdate: (option)-> option is 'update'
  optionIsSubmit: (option)-> option is 'submit'
  afterDeadline: (homework)-> homework.deadline < Date.now!
  getStartDate: -> moment(this.startDate).format('YYYY-MM-DD HH:mm')
  getDeadline: (homework)-> moment(homework.deadline).format('YYYY-MM-DD HH:mm')
  parseDeadline: (homework)-> moment(homework.deadline).format('YYYY-MM-DDTHH:mm')
}


Template['form'].events {

  'submit .submit': (ev, tpl)->
    submission = Submissions.find-one {student: ev.target.student.value, homeworkName: ev.target.homeworkName.value}
    if (typeof submission) is 'object'
      Submissions.update {_id: submission._id}, {$set: {commitment: ev.target.commitment.value, uploadDate: Date.now!}}, {multi: false}, (error, count)!->
        if error then console.log error else if count then console.log count;$ '#message' .text 'Submit succeed.'
    else
      submission =
        * homeworkName: ev.target.homeworkName.value
          student: ev.target.student.value
          uploadDate: Date.now!
          filename: null
          commitment: ev.target.commitment.value
          grades: null
      Submissions.insert submission
      homework = Homeworks.find-one {homeworkName: ev.target.homeworkName.value}
      Homeworks.update {_id: homework._id}, {$inc: {uploaded: 1}}, (error, count)!-> if error then console.log error

  'submit .update': (ev, tpl)->
    ev.prevent-default!
    $ '#message' .text ''
    current-homework = Homeworks.find-one {homeworkName: ev.target.homeworkName.value}
    if current-homework?
      new-requirement = ev.target.requirement.value if current-homework.requirement isnt ev.target.requirement.value
      new-date = new Date ev.target.deadline.value.replace('T', ' ')
      if new-date.get-time! < current-homework.deadline
        $ '#message' .text 'Only delay is allowed.'
      else
        new-deadline = new-date if new-date.get-time! isnt current-homework.deadline
      current-homework-change = {}
      if new-requirement? then current-homework-change.requirement = new-requirement
      if new-deadline? then current-homework-change.deadline = new-deadline
      if current-homework-change.requirement? or current-homework-change.deadline?
        Homeworks.update {_id: current-homework._id}, {$set: current-homework-change}, {multi: false}, (error, count)!->
          if error then console.log error else $ '#message' .text 'Update succeed.'

  'submit .create': (ev, tpl)->
    ev.prevent-default!
    if (typeof Homeworks.find-one homeworkName: ev.target.homeworkName.value) is 'object'
      $ '#message' .text 'This homework already exists.'
    else
      new-homework =
        * homeworkName: ev.target.homeworkName.value
          requirement: ev.target.requirement.value
          uploaded: 0
          startDate: Date.now!
          deadline: new Date ev.target.deadline.value.replace('T', ' ')
      Homeworks.insert new-homework, (error, _id)!-> if error then console.log error else $ '#message' .text 'Create succeed.'
}

Template['form'].on-rendered ->
  $ '#requirement-textbox' .text ($ '#requirement-box' .text!)

  $ '#file-upload' .bind 'focusout', ->
    array = this.value.split('.zip')
    if (array.length > 0 and array[array.length-1] isnt '')
      $ '#message' .text 'Zip files only and no empty files.'
      $ this .parents '.textbox' .addClass 'has-error'
      $ '.form-horizontal button' .attr 'disabled', true
      $ this .focus!
    else
      $ '#message' .text ''
      $ this .parents '.textbox' .removeClass 'has-error'
      $ '.form-horizontal button' .attr 'disabled', false

  $ 'textarea, input[type="text"]' .each ->
    if ($ '.form-horizontal button' .attr 'disabled') == 'disabled'
      return
    $ this .bind 'focusout', ->
      $ '#message' .text ''
      if (this.value.replace /\s/g, "" .length == 0)
        $ this .parents '.textbox' .addClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', true
        $ '#message' .text 'Empty input not allowed.'
        $ this .focus!
      else
        $ this .parents '.textbox' .removeClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', false

  $ '.create input[type="datetime-local"]' .each ->
    $ this .bind 'focusout', ->
      $ '#message' .text ''
      new-date = new Date this.value
      if new-date < Date.now!
        $ this .parents '.textbox' .addClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', true
        $ '#message' .text 'Invalid date not allowed.'
        $ this .focus!
      else
        $ this .parents '.textbox' .removeClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', false
