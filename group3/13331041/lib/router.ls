history = new Date()
year = history.getFullYear!
month = history.getMonth!+1
hour = history.getHours!
minute = history.getMinutes!
if month < 10
  month = '0'+month.toString!
day = history.getDate!
if day < 10
  day = '0'+day.toString!
if hour < 10
  hour = '0'+hour.toString!
if minute < 10
  minute = '0'+minute.toString!
date = year+'-'+month+'-'+day
time = hour+':'+minute


Router.configure  layoutTempate:'layout' loadingTemplate: 'loading'

Router.route '/', name:'login'

Router.route '/home' name:'home'

Router.route '/create', name:'create'

Router.route '/history', name:'history'

Router.route '/submit', name:'submit'