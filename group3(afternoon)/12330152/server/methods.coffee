MyUsers = new Mongo.Collection 'myUsers'
Homeworks = new Mongo.Collection 'homeworks'

# validators
validateArgs = (args, validators)->
    for i in [0...validators.length]
        return false if not validators[i] args[i]
    return true
validString = (str)-> str and typeof str == 'string'
validRole = (role)-> role == 'Teacher' or role == 'Student'
validDate = (date)-> date instanceof Date

validateRole = (role)->
    user = ServerSession.get 'myUser'
    return user and ((not role) or role == user.role)

Meteor.methods
    myRegister: (username, password, role)->
        # validate args
        return if not validateArgs arguments, [validString, validString, validRole]
        # check username
        return msg: 'username exists' if MyUsers.find(username: username).count()
        # insert
        MyUsers.insert
            username: username
            password: password
            role: role
        # set session
        ServerSession.set 'myUser',
            username: username
            role: role
        return msg: 'ok'

    myLogin: (username, password)->
        # validate args
        return if not validateArgs arguments, [validString, validString]
        # check username & password
        users = MyUsers.find(
            username: username
            password: password
        ).fetch()
        return msg: 'bad username/password' if users.length == 0
        # set session
        ServerSession.set 'myUser',
            username: username
            role: users[0].role
        return {
            msg: 'ok'
            role: users[0].role
        }

    myLogout: ()->
        # remove session
        ServerSession.set 'myUser', null
        return msg: 'ok'

    createHomework: (title, details, deadline)->
        # validate role
        return if not validateRole 'Teacher'
        # validate args
        return if not validateArgs arguments, [validString, validString, validDate]
        # insert
        Homeworks.insert
            title: title
            details: details
            deadline: deadline
            pubDate: new Date
            submits: []
        return msg: 'ok'

    getHomeworks: ()->
        # validate role
        return if not validateRole()
        # query all homeworks
        homeworks = Homeworks.find({},{sort: {pubDate: -1}}).fetch()
        # submits shouldn't be returned
        homeworks.forEach (homework)-> delete homework.submits
        return {
            msg: 'ok'
            homeworks: homeworks
        }

    getHomework: (id)->
        # validate role
        return if not validateRole()
        # validate args
        return if not validateArgs arguments, [validString]
        homework = Homeworks.find(_id: id).fetch()[0]
        user = ServerSession.get 'myUser'
        role = user.role
        # return only his own submit for a student
        if role == 'Student'
            homework.submit = (homework.submits.filter (submit)-> submit.username == user.username)[0]
            delete homework.submits
        return {
            msg: 'ok'
            homework: homework
        }

    modifyHomework: (id, title, details, deadline)->
        # validate role
        return if not validateRole 'Teacher'
        # validate args
        return if not validateArgs arguments, [validString, validString, validString, validDate]
        # update (validating deadline)
        count = Homeworks.update {
            _id: id
            deadline:
                $gt: new Date
        }, $set:
            title: title
            details: details
            deadline: deadline
        homework = Homeworks.find(_id: id).fetch()[0]
        if count
            return {
                msg: 'ok'
                homework: homework
            }
        else
            return

    grade: (id, username, score)->
        # validate role
        return if not validateRole 'Teacher'
        # validate args
        return if not validateArgs arguments, [validString, validString, validString]
        # query the homework
        homework = Homeworks.find(_id: id).fetch()[0]
        # validate deadline
        return if homework.deadline > new Date
        # find and modify the submit
        submits = homework.submits
        submits.forEach (submit)-> submit.score = score if submit.username == username
        # update
        Homeworks.update {_id: id}, {$set:{submits: submits}}
        return msg: 'ok'

    submit: (id, solution)->
        # validate role
        return if not validateRole 'Student'
        # validate args
        return if not validateArgs arguments, [validString, validString]
        # query the homework
        homework = Homeworks.find(_id: id).fetch()[0]
        # validate deadline
        return if homework.deadline < new Date
        submits = homework.submits
        username = ServerSession.get('myUser').username
        submitExists = false
        # modify if exists
        for submit in submits
            if submit.username == username
                submit.solution = solution
                submitExists = true
        # push if not exists
        if not submitExists
            submits.push
                username: username
                solution: solution
                score: null
        # update
        Homeworks.update {_id: id}, {$set:{submits: submits}}
        return msg: 'ok'
