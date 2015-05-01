Router.configure layoutTemplate: 'layout'

Router.on-after-action !-> document.title = 'MyHomework'

Router.route '/', !-> @render 'mainpage'

Router.route '/publish', !-> @render 'publish'

Router.route '/modify', !-> @render 'modify'

Router.route '/submit', !-> @render 'submit'
