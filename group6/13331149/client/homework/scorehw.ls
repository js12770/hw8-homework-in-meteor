Template.scorehw.helpers {
  homeworks: -> Homeworks.find!.fetch!

  is-teacher: -> Meteor.user!.profile.role == 'teacher' ? true : false

  get-score: (submits)->
    for submit in submits
      if submit.student == Meteor.user!?.username
        return submit.score
    return
    
  is-after-deadline: (date, time)-> 
    nowtime = new Date
    now = nowtime.get-full-year().to-string!
    if nowtime.get-month! < 10 then now += '0'+ (nowtime.get-month!+1).to-string!
    else now += nowtime.get-month!.to-string!+'1'
    if nowtime.get-date! < 10 then now += '0'+ nowtime.get-date!.to-string!
    else now += nowtime.get-date!.to-string!
    if nowtime.get-hours! < 10 then now += '0'+ nowtime.get-hours!.to-string!
    else now += nowtime.get-hours!.to-string!
    if nowtime.get-minutes! < 10 then now += '0'+ nowtime.get-minutes!.to-string!
    else now += nowtime.get-minutes!.to-string!
    deadline = date.replace /-/g, ""
    deadline += time.replace ':', ""
    deadline < now ? true : false
}