Requirements = new Mongo.Collection 'requires'

Requirements.allow {
  insert: (username, doc) -> username?
  update: (username, doc) -> username?
}

root = exports ? this
root.Requirements = Requirements