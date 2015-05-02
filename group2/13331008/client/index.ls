Accounts.ui.config passwordSignupFields: "USERNAME_ONLY"

Accounts.on-login !->
  Session.set 'selectedAssignmentId', void
  Session.set 'selectedHomeworkId', void
