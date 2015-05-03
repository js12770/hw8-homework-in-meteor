function loadUser(user) {
  if (typeof(Meteor.users.findOne({username:user.username})) == 'object') {
  } else {
    id = Accounts.createUser(user);
    Roles.addUsersToRoles(id, user.roles);
  }
};
function loadHomework(homework) {
  if (typeof(Homeworks.findOne({title:homework.title})) == 'object') {
  } else {
    Homeworks.insert(homework);
  }
};
function loadSubmit(submit) {
  if (typeof(Submits.findOne({_title:submit._title})) == 'object') {
  } else {
    Submits.insert(submit);
  }
};
function getDateTimeString(date) {
  var month = (date.getMonth()+1 >= 10) ? date.getMonth()+1 : "0"+(date.getMonth()+1);
  var day = (date.getDate() >= 10) ? date.getDate() : "0"+date.getDate();
  var hour = (date.getHours() >= 10) ? date.getHours() : "0"+date.getHours();
  var minute = (date.getMinutes() >= 10) ? date.getMinutes() : "0"+date.getMinutes();
  var datetime = date.getFullYear()+"-"+month+"-"+day+" "+hour+":"+minute;
  return datetime;
};

Meteor.startup(function() {
  var user1 = {
    username: 'Eric',
    password: 'password',
    email: 'eric@example.com',
    roles: ['teacher'],
    profile: {
      'first-name': 'Wang',
      'last-name': 'Qing',
    }
  }
  loadUser(user1);

  var user2 = {
    username: '123',
    password: '123123',
    email: '123123@example.com',
    profile: {
      'first-name': '123',
      'last-name': '123',
    }
  }
  loadUser(user2);

  var s_date1 = new Date(2015,3,20,7,0,0);
  var e_date1 = new Date(2015,3,22,12,0,0);
  var s_d = getDateTimeString(s_date1);
  var e_d = getDateTimeString(e_date1);
  var homework1 = {
    title       : 'Homework1',
    author      : 'Eric', 
    description : 'This is homework1. It is so easy.',
    start       : s_d,
    end         : e_d,
    submits     : '0'
  }
  loadHomework(homework1);

  var s_date2 = new Date(2015,3,22,16,0,0);
  var e_date2 = new Date(2015,4,1,12,0,0);
  var s_d2 = getDateTimeString(s_date2);
  var e_d2 = getDateTimeString(e_date2);
  var homework2 = {
    title       : 'Homework2',
    author      : 'Eric', 
    description : 'Homework2 is very diffcult.',
    start       : s_d2,
    end         : e_d2,
    submits     : '0'
  }
  loadHomework(homework2);

  var date1 = new Date(2015,3,20,0,0,0);
  var d1 = getDateTimeString(date1);
  var submit1 = {
    _title       : 'Submit for Homework1',
    _author      : '123', 
    _description : 'Yes, I love homework1',
    _homework    : 'Homework1',
    _date        : d1,
    _grade       : null
  }
  loadSubmit(submit1);

  var date2 = new Date(2015,3,25,19,0,0);
  var d2 = getDateTimeString(date2);
  var submit2 = {
    _title       : 'Submit for Homework2',
    _author      : '123', 
    _description : 'Oh, no. I hate homework2!',
    _homework    : 'Homework2',
    _date        : d2,
    _grade       : null
  }
  loadSubmit(submit2);
});
