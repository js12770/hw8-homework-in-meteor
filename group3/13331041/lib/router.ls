Router.configure  layoutTempate:'layout' loadingTemplate: 'loading'

Router.route '/', name:'login'

Router.route '/home' name:'home'

Router.route '/create', name:'create'

Router.route '/history', name:'history'

Router.route '/submit', name:'submit'