Template.body.events {
  'click #home': ->
    Session.set 'currentState', null
}

if Meteor.is-client
  Accounts.ui.config {
    password-signup-fields: "USERNAME_ONLY"
  }
