Meteor.startup ->
  Uploader.uploaderUrl = Meteor.absoluteUrl 'upload'