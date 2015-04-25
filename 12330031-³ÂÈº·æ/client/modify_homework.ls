Template['modify_homework'].events {
  'click .button.cancel': (ev, tpl)!->
    ($ '#detail').show!
    ($ '#modify-homework').hide!
  'click .button.submit_modify_homework': (ev, tpl)-> 
    ev.prevent-default!
    title = ($ 'input[name=title_modify]').val!
    console.log title
    date = new Date(($ 'input[name=date_modify]').val!)
    description = ($ 'textarea[name=description_modify]').val!
    id = ($ 'dl').attr('id')
    homework = Homeworks.findOne $or: [{'_id': id}]
    console.log homework
    if homework then 
      homework.title = title
      homework.date = date
      homework.description = description
      console.log homework
      [Homeworks.update {'_id': id}, $set: {'title':title,'date':date,'description':description}]
      ($ '#detail').show!
      ($ '#modify-homework').hide!
    else
      alert 'error'
}
