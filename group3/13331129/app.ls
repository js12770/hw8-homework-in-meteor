root = exports ? @
root.Tasks = new Meteor .Collection "tasks"
root.Homeworks = new Meteor .Collection "homeworks"
root.Images = new FS.Collection "images", {
	stores: [new FS.Store.FileSystem "picture", {path: "~/uploads"}]
}

root.Files = new FS.Collection "files", {
	stores: [new FS.Store.FileSystem "file", {path: "~/uploads"}]
}

root.Meteor.startup ->
	if root.Meteor.is-client
		root.Meteor .subscribe "tasks"
		root.Meteor .subscribe "images"
		root.Meteor .subscribe "homeworks"
		root.Meteor .subscribe "files"

Images .allow {
	insert: (file) ->
		true
	update: (file) ->
		true
	download: (file) ->
		true
}

Files .allow {
	insert: (file) ->
		true
	update: (file) ->
		true
	download: (file) ->
		true
}

Homeworks .allow {
	insert: (file) ->
		true
	update: (file) ->
		true
}