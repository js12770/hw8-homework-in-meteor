Accounts.ui.config({
    passwordSignupFields: 'USERNAME_ONLY',
    requestPermissions: {},
    extraSignupFields: [{
        fieldName: 'first-name',
        fieldLabel: 'First name',
        inputType: 'text',
        visible: true,
        validate: function(value, errorFunction) {
          if (!value) {
            errorFunction("Please write your first name");
            return false;
          } else {
            return true;
          }
        }
    }, {
        fieldName: 'last-name',
        fieldLabel: 'Last name',
        inputType: 'text',
        visible: true,
    }, {
        fieldName: 'status',
        fieldLabel: 'Status',
        inputType: 'text',
        visible: true,
        validate: function(value, errorFunction) {
          if (value != 'teacher'&&value != 'student') {
            errorFunction("Please input teacher or student");
            return false;
          } else {
            return true;
          }
        }
    }]
});