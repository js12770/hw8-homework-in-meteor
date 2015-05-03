if Meteor.is-client
  Accounts.ui.config {
    requestPermissions: {},
    extraSignupFields: [{
      fieldName: 'firstName',
      fieldLabel: 'First name',
      inputType: 'text',
      visible: true,
      validate: (value, errorFunction)-> 
        if !value
          errorFunction "Please write your first name"
          false
        else
          true
    }, {
      fieldName: 'lastName',
      fieldLabel: 'Last name',
      inputType: 'text',
      visible: true,
      validate: (value, errorFunction)-> 
        if !value
          errorFunction "Please write your last name"
          false
        else
          true
    }],
    passwordSignupFields: 'USERNAME_AND_EMAIL'
  }

  Accounts.on-login -> Router.go 'home'

