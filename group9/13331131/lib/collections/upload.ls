FilesFS = new FS.Collection 'files', {
  stores: [new FS.Store.FileSystem 'uploads', path: '~/Desktop/myhw/uploads']
}

FilesFS.allow { 
  insert: (userId, party)-> true
  update: (userId, party)-> true
  remove: (userId, party)-> true
  download: (userId, party)-> true
}

root = exports ? this
root.FilesFS = FilesFS