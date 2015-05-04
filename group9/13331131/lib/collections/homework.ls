Homeworks = new Mongo.Collection 'homeworks'

Homeworks.allow {
  insert: (username, doc) -> username?
}

root = exports ? this
root.Homeworks = Homeworks