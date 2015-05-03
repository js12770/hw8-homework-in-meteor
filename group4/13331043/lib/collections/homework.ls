root = exports ? @
root.Homework = new Mongo.Collection 'Homework'

Homework.allow {
  insert: (user-id, doc) ->
    user-id
  update: (user-id, doc) ->
    user-id
}
