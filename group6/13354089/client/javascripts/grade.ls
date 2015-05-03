Template['grade'].helpers {
  user: -> Meteor.user!
  getUploadDate: -> moment(this.uploadDate).format('YYYY-MM-DD HH:mm')
  afterDeadline: (homework)-> homework.deadline < Date.now!
}

Template['grade'].events {
  'submit .grade': (ev, tpl)->
    ev.prevent-default!
    if (typeof submission = Submissions.find-one {homeworkName: ev.target.homework.value, student: ev.target.student.value}) is 'object'
      Submissions.update {_id: submission._id}, {$set: {grades: ev.target.grades.value}}, {multi: false}, (error, count)!->
        if error then console.log error else if count then console.log count;$ '#message' .text 'Grade succeed.'
    else
      $ '#message' .text 'This submission not exists.'
}