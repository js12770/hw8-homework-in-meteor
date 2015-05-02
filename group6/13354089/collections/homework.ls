root = exports ? @

root.Homeworks = new Mongo.Collection 'homeworks'

/*
Homeworks.allow {
  insert: (userId, doc)-> userId && doc.owner is userId,
  update: (userId, doc, fields, modifier)-> doc.owner is userId,
  fetch: ['owner']
}

Homeworks.deny {
  update: (userId, docs, fields, modifier)-> _.contains(fields, 'owner'),
  fetch: ['locked']
}
*/

