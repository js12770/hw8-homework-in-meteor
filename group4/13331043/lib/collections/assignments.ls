root = exports ? @
root.Assignment = new Mongo.Collection 'Assignment'

Assignment.allow {
  insert: (user-id, doc) ->
    user-id
  update: (user-id, doc) ->
    user-id
}
