window.myUser = new ReactiveVar null, (a, b)->
    return true if (not a) and (not b)
    return false if not (a and b)
    return a.username == b.username

exports = {}

exports.setView  = (view)-> Session.set 'view', view

exports.getUser = ()-> Session.get 'myUser'
exports.setUser = (user)-> Session.set 'myUser', user

exports.isTeacher = ()-> Session.get('myUser').role == 'Teacher'

exports.methodHandler = (ok)->(err, res)->
    if err
        alert err
    else if res.msg == 'ok'
        ok(res)
    else
        alert res.msg

_months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

pad2 = (num)-> if num < 10 then "0#{num}" else "#{num}"

exports.formatDate = (dateObj, utc)->
    if utc
        minutes = dateObj.getUTCMinutes()
        hours = dateObj.getUTCHours()
        date = dateObj.getUTCDate()
        month = dateObj.getUTCMonth()
        year = dateObj.getUTCFullYear()
    else
        minutes = dateObj.getMinutes()
        hours = dateObj.getHours()
        date = dateObj.getDate()
        month = dateObj.getMonth()
        year = dateObj.getFullYear()
    return "#{pad2 hours}:#{pad2 minutes} on #{_months[month]} #{date}, #{year}"

window.utils = exports
