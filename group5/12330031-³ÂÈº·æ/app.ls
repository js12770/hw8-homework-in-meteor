root = exports ? @

root.Students = new Mongo.Collection 'Students'

root.Homeworks = new Mongo.Collection 'Homeworks'

root.Homeworks = new Mongo.Collection 'Attachments'

Meteor.methods {
  'remove-all-students': -> Homeworks.remove {} 
  'add-fake-students': -> for i in [1 to 108]
    Students.insert student-id: i, name: i
}

Router.route '/', ->
  
Router.route '/:_id', ->
  ($ '.main .container').hide!
  ($ '#detail').show!
  id = this.params._id
  homework = Homeworks.findOne $or: [{'_id': id}]
  Session.set('_homework', homework) 

Meteor.startup -> 
  if Meteor.is-client
    Session.setDefault('_homework', {})
    $ 'form[data-parsley-validate]' .parsley!
