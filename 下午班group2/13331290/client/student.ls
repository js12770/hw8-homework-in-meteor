after-deadline-for-revising-homework = !->
  date = new Date!
  year = date.get-full-year! + ''
  if date.get-month! < 10 then month = '0' + (date.get-month! + 1) else month = (date.get-month! + 1) + ''
  if date.get-date! < 10 then day = '0' + date.get-date! else day = date.get-date! + ''
  if date.get-hours! < 10 then hours = '0' + date.get-hours! else hours = date.get-hours! + ''
  if date.get-minutes! < 10 then minutes = '0' + date.get-minutes! else minutes = date.get-minutes! + ''
  now-moment = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes

  homeworks = $ '.assignment-table tbody tr'

  for homework in homeworks
    homework = $ homework
    deadline = homework.find '.before-deadline'
    detail-btn = homework.find '.detail'
    if deadline.text! <= now-moment
      deadline.remove-class 'before-deadline' .add-class 'after-deadline'
      detail-btn.add-class 'disabled'

Template['student'].helpers {
  assignment_list: -> Assignments.find {}, {sort: {deadline: -1}}
  assignment: -> Assignments.find-one {_id: Session.get 'assignmentId'}
  isMyScore: (myId)-> myId == Meteor.userId!
  changeTimeFormat: (time)-> time.replace 'T', ' ' 
}

Template['student'].events {
  'click .assignment-table .detail': (e)!->
    return if $ e.target .has-class 'disabled'
    Session.set 'assignmentId', e.target.id
    $ '.assignment-table' .add-class 'hidden'
    $ '.view-assignment' .remove-class 'hidden'

  'click .view-assignment .back': !->
    $ 'input[type=\'file\']' .val ''
    $ '.assignment-table' .remove-class 'hidden'
    $ '.view-assignment' .add-class 'hidden'
    after-deadline-for-revising-homework!

  'submit .submit-assignment': (e)!->
    e.prevent-default!
    filePath = (Submissions.insert e.target.file.files[0]).url {brokenIsFine: true}
    Meteor.call 'submit-assignment' e.target.assignmentId.value, filePath
    $ '.view-assignment .back' .trigger 'click'
}

Template['student'].on-rendered !-> after-deadline-for-revising-homework!
