Homeworks = new Mongo.Collection 'homeworks'

Homeworks.allow {
	insert: (userId, doc) ->
		!!userId
	update: (userId, post) ->
		!!userId
	remove: (userId, post) -> 
		!!userId
}

root = exports ? this
root.Homeworks = Homeworks
