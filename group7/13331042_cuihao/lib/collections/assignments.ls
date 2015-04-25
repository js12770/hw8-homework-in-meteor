Assignments = new Mongo.Collection 'assignments'

Assignments.allow {
	insert: (userId, doc) ->
		!!userId
	update: (userId, post) ->
		!!userId
	remove: (userId, post) -> 
		!!userId
}

root = exports ? this
root.Assignments = Assignments
