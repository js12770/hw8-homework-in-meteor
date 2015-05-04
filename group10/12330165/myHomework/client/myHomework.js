Template.studentNavigation.onRendered(function () {
    var theContent = $('.right-container');
    $('#lookHomework').click(function() {
        theContent.children().remove();
        UI.render(Template.allhomework, theContent[0]);
    });
    $('#uploadHomework').click(function() {
        theContent.children().remove();
        UI.render(Template.uploader, theContent[0]);
    });
    $('#Register').click(function() {
        theContent.children().remove();
        UI.render(Template.register, theContent[0]);
    });
    /*
    var logoutArea = document.getElementById("logoutArea");
    $(logoutArea).find("input[type=button]").click(function() {
        Session.set("User", '');
        $("#main-container").children().remove();
        UI.render(Template.login, $("#main-container")[0]);
    });
    */
});

Template.teacherNavigation.onRendered(function() {
    var theContent = $('.right-container');
    $('#lookHomework').click(function() {
        theContent.children().remove();
        UI.render(Template.allhomework, theContent[0]);
    });
    $('#sponsorHomework').click(function() {
        theContent.children().remove();
        UI.render(Template.sponsorHomeWork, theContent[0]);
    });
    /*
    var logoutArea = document.getElementById("logoutArea");
    $(logoutArea).find("input[type=button]").click(function() {
        Session.set("User", '');
        $("#main-container").children().remove();
        UI.render(Template.login, $("#main-container")[0]);
    });
    */
});

Template.login.onRendered(function() {
    var user = Session.get("User");
    if (user) {
        if (user.privilege == 2) {
            $("#main-container").children().remove();
            UI.render(Template.teacher, $("#main-container")[0]);
        } else {
            $("#main-container").children().remove();
            UI.render(Template.student, $("#main-container")[0]);
        }
        return;
    }
    var loginButton = $("input[type=button]")[0];
    $(loginButton).click(function() {
        var userID = $("input[type=text]").val();
        var userPassword = $("input[type=password]").val();
        var userInfo = {
            userID: userID,
            userPassword: userPassword
        }
        Meteor.call("checkLogin", userInfo, function(err, result) {
            if (err) console.log(err);
            if (!result) {
                alert("不存在的用户或者密码错误！");
            } else {
                Session.set("User", result);
                if (result.privilege == 2) {
                    $("#main-container").children().remove();
                    UI.render(Template.teacher, $("#main-container")[0]);
                } else {
                    $("#main-container").children().remove();
                    UI.render(Template.student, $("#main-container")[0]);
                }
            }
        });
    });

    var registerButton = $("input[type=button]")[1];
    $(registerButton).click(function() {
        $("#main-container").children().remove();
        UI.render(Template.student, $("#main-container")[0]);
        $($("#main-container").children()[1]).children().remove();
        UI.render(Template.register, $("#main-container").children()[1]);
    });
});

Template.register.onRendered(function() {
    var submitButton = $("input[type=button]");
    submitButton.click(function() {
        var userID = $($("input[type=text]")[0]).val();
        var userPassword = $($("input[type=password]")[0]).val()
        Meteor.call("addUser", {userID: userID, userPassword: userPassword}, function(result) {
            if (result) {
                alert("注册成功");
            } else {
                alert("注册失败");
            }
        });
    });
});

Template.sponsorHomeWork.onRendered(function() {
    var submitButton = $("input[type=button]");
    submitButton.click(function() {
        var insertData = {
            title: $("input[name=title]").val(),
            deadline: $("input[name=deadline]").val(),
            content: $("input[name=content]").val()
        }
        Meteor.call('addHomework', insertData, function(err, res) {
            if (res) alert("发布成功!");
        });
    });
});

Template.allhomework.onRendered(function() {
    var homeworks;
    Meteor.call("allhomework", function(err, response) {
        if (err) console.log(err);
        homeworks = response;
    });
    Template.allhomework.helpers({
        homeworks: function() {
            return homeworks;
        }
    });
});

Template.uploader.onRendered(function() {
    var homeworkTitles = new Array();
    Meteor.call("allhomework", function(err, response) {
        if (err) console.log(err);
        for (var i = 0; i < response.length; i++) {
            homeworkTitles.push({
                title: response[i].title
            });
        }
    });
    Template.uploader.helpers({
        titles: function() {
            return homeworkTitles;
        }
    });
    $('#uploader-button').click(function() {
        $(':file').click();
    });
    $(':file').change(function() {
        var file = this.files[0];
        $('#filename').val(file.name);
    });
    function progressHandlingFunction(e) {
        if (e.lengthComputable) {
            $('progress').attr({value: e.loaded, max: e.total});
        }
    }
    $('#submit-button').click(function() {
        var formData = new FormData($('form')[0]);
        var obj = $('select option:selected');
        formData.append('title', obj.html());
        $.ajax({
            type: 'POST',
            url: '/main/upload',
            xhr: function() {
                var myXhr = $.ajaxSettings.xhr();
                if (myXhr.upload) {
                    myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                }
                return myXhr;
            },
            data: formData,
            success: function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type) {
                    self.parent.location.replace('/main');
                }
            },
            cache: false,
            contentType: false,
            processData: false
        });
    });
});