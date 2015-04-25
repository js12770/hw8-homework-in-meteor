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
    revise-btn = homework.find '.revise'
    edit-btn = homework.find '.edit'
    delete-btn = homework.find '.delete'
    if deadline.text! <= now-moment
      deadline.remove-class 'before-deadline' .add-class 'after-deadline'
      revise-btn.remove-class 'hidden'
      edit-btn.add-class 'hidden'
      delete-btn.add-class 'hidden'

Template['teacher'].events {
  'click .all-assignments': !->
    $ '.all-assignments' .add-class 'tab-highlight'
    $ '.publish-assignments' .remove-class 'tab-highlight'
    $ '.assignment-table' .remove-class 'hidden'
    $ '.edit-assignment, .publish-assignment, .revise-assignment' .add-class 'hidden'
    after-deadline-for-revising-homework!

  'click .publish-assignments': !->
    $ '.publish-assignments' .add-class 'tab-highlight'
    $ '.all-assignments' .remove-class 'tab-highlight'
    $ '.publish-assignment' .remove-class 'hidden'
    $ '.edit-assignment, .assignment-table, .revise-assignment' .add-class 'hidden'
}

Template['teacher'].on-rendered !-> after-deadline-for-revising-homework!
