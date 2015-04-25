Template['assign'].events {
  'click .button.clear': (ev, tpl)!->
     $ 'input' .val ''
     $ 'textarea' .val ''
  'click .button.submit': (ev, tpl)-> 
    ev.prevent-default!
    title = ($ 'input[name=title]').val!
    ddl = new Date(($ 'input[name=ddl]').val!)
    require = ($ 'textarea[name=require]').val!
    Homework.insert homework = {title, ddl, require}
}