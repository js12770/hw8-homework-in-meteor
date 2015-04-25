if (Meteor.isClient) {

  Accounts.ui.config({
  passwordSignupFields: "USERNAME_ONLY"
});

  Template.body.helpers({
    isAdmin: function() {
      return Meteor.user().username === 'admin'
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}

