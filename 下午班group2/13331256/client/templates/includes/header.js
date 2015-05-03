Template.header.events({
  'click .add-presence': function(e) {
    if (!Meteor.user()) throw new Meteor.Error("not-authorized");
    if (Meteor.user().profile.presence) return;
    Meteor.users.update(Meteor.userId(), {$set: {"profile.presence": e.target.value}});
  }
});

Template.header.helpers({
  isStudent: function() {
    return Meteor.user().profile.presence === "student";
  }
})