root = exports ? @

root.Content = new Mongo.Collection 'Content'

root.Content.allow {
    update: (userId, post)->
        ownsDocument userId, post
    remove: (userId, post)->
        ownsDocument user, post
}

root.Content.deny {
    update: (userId, psot, field-names)->
        _.without field-names, 'content' .length > 0
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
