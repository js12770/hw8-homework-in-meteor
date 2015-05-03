root = exports ? @

root.Content = new Mongo.Collection 'Content'

root.Content.allow {
    insert: (user-id, post)->
        user = Meteor.user!
        if user._id is user-id and user.profile is 'student'
            return true
        else
            return false
    update: (userId, post)->
        return true
    remove: (userId, post)->
        ownsDocument userId, post
}

root.Content.deny {
    update: (userId, post, field-names)->
        _.without field-names, 'content', 'score' .length > 0
}

Meteor.methods {
    content-insert: (content-attributes)->
        check this.user-id, String
        check content-attributes, { contents: String }
        user = Meteor.user!
        content = _.extend content-attributes, {
            author: user._id,
            submitted: new Date()
        }
        post-id = Content.insert content
        return {
            _id: post-id
        }
}
