root = exports ? @

root.Homework = new Mongo.Collection('Homework')

root.Homework.allow {
    insert: (user-id, post)->
        return !! user-id
    update: (userId, post)->
        return true
    remove: (uerId, post)->
        return true
}

root.Homework.deny {
    update: (userId, post, field-names)->
        _.without field-names, 'title', 'demand', 'deadline' .length > 0
    }

Meteor.methods {
    homework-insert: (homework-attributes)->
        check this.user-id, String
        check homework-attributes, {
           title: String,
           deadline: Date
        }
        if Homework.find-one {title: homework-attributes.title}
            return {
                homework-exist: true,
            }

        user = Meteor.user()
        homework = _.extend homework-attributes, {
            teacher-id: user._id,
            teacher-name: user.username,
            submitted: new Date(),
        }
        post-id = Homework.insert homework

        return {
            _id: post-id
        }
}
