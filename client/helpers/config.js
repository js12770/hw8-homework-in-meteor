Accounts.ui.config({
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
        visible: true
    }, {
        fieldName: 'identity',
        fieldLabel: '"S" for "student", "T" for "teacher"',
        inputType: 'text',
        visible: true,
        validate: function(value, errorFunction) {
          if (value != 'S' && value != 'T') {
            errorFunction("Please input your correct identity");
            return false;
          } else {
            return true;
          }
        }
    }]
});

accountsUIBootstrap3.logoutCallback = function(error) {
  if(error) console.log("Error:" + error);
  Router.go('/');
}

Accounts.onLogin(function(){
  Router.go('/home');
});
