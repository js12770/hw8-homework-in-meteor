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
    submission =
      * homeworkName: ev.target.name.value
        student: ev.target.student.value
        uploadDate: Date.now!
        filename: null
        commitment: ev.target.commitment.value
        grades: null
    Submissions.insert submission

  'submit .update': (ev, tpl)->
    ev.prevent-default!
    $ '#message' .text ''
    current-homework = Homeworks.find-one {homeworkName: ev.target.name.value}
    if current-homework?
      new-requirement = ev.target.requirement.value if current-homework.requirement isnt ev.target.requirement.value
      new-date = new Date ev.target.deadline.value.replace('T', ' ')
      console.log new-date+'miiiiaaaooo'+current-homework.deadline.get-time!
      if new-date.get-time! < current-homework.deadline.get-time!
        $ '#message' .text 'Only delay is allowed'
      else
        new-deadline = new-date if new-date.get-time! isnt current-homework.deadline.get-time!
      current-homework-change = {}
      if new-requirement? then current-homework-change.requirement = new-requirement
      if new-deadline? then current-homework-change.deadline = new-deadline
      console.log current-homework-change
      if current-homework-change.requirement? or current-homework-change.deadline?
        /*console.log */
        Homeworks.update {_id: current-homework._id}, {$set: current-homework-change}, {multi: false}, (error, count)!->
          if error then console.log error else if count then console.log count;$ '#message' .text 'Update succeed.'
        $ '#message' .text 'Update succeed'

  'submit .create': (ev, tpl)->
    ev.prevent-default!
    if (typeof Homeworks.find-one homeworkName: ev.target.name.value) is 'object'
      $ '#message' .text 'This homework already exists.'
    else
      new-homework =
        * homeworkName: ev.target.name.value
          requirement: ev.target.requirement.value
          uploaded: 0
          startDate: Date.now!
          deadline: new Date ev.target.deadline.value.replace('T', ' ')
      console.log new-homework
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
      if (this.value.replace /\s/g, "" .length == 0)
        $ this .parents '.textbox' .addClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', true
        console.log 'Empty input not allowed.'
        $ this .focus!
      else
        $ this .parents '.textbox' .removeClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', false

  $ '.create input[type="datetime-local"]' .each ->
    if ($ '.form-horizontal button' .attr 'disabled') == 'disabled'
      return
    $ this .bind 'focusout', ->
      console.log new-date = new Date this.value
      console.log new-date < Date.now!
      if new-date < Date.now!
        $ this .parents '.textbox' .addClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', true
        console.log 'Invalid date not allowed.'
        $ this .focus!
      else
        $ this .parents '.textbox' .removeClass 'has-error'
        $ '.form-horizontal button' .attr 'disabled', false
