Accounts.ui.config({
    requestPermissions: {},
    extraSignupFields: [{
        fieldName: 'firstName',
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
        fieldName: 'lastName',
        fieldLabel: 'Last name',
        inputType: 'text',
        visible: true,
    }, {
        fieldName: 'identity',
        fieldLabel: "'teacher' or 'student'",
        inputType: 'text',
        visible: true,
        validate: function(value, errorFunction) {
            if (value != 'teacher' && value != 'student') {
                errorFunction("You must input either 'teacher' or 'student'");
                return false;
            } else {
                return true;
            }
        }
    }],
    passwordSignupFields: 'EMAIL_ONLY'
});