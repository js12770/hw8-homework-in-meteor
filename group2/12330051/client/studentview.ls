Template['studentview'].helpers {
	Hrequirment: !->
		therequirment =Homework.findOne {title:'onlyone'}
		if therequirment
			return therequirment.requirement
		else
			return '目前没有发布作业'
	Hdeadline: !->
		thedeadline =Homework.findOne {title:'onlyone'}
		if thedeadline
			return thedeadline.deadline
		else
			return '无'
	myassignment: !->
		theassignment = Assignment.findOne {name: Meteor.user().username}
		if theassignment
			return theassignment.assignment
		else 
			return '未提交'
	myscore: !->
		theassignment = Assignment.findOne {name: Meteor.user().username}
		if theassignment
			return theassignment.score
		else 
			return '无'
}
Template['studentview'].events {
	'click .updatehomework': !->
		thehw = Homework.findOne {title:'onlyone'}
		if thehw
			if thehw.deadline.getTime! > Date.now!
				theassignment = Assignment.findOne {username: Meteor.user().username}
				if theassignment
					Assignment.update {name:Meteor.user().username}, {$set:{assignment:$ 'textarea[name='studenthomework']' .val!}}
				else
					Assignment.insert {name:Meteor.user().username, assignment:$ 'textarea[name='studenthomework']' .val! ,score: '未评分' }
			else
				alert '截至日期已过！'
		else
			alert '目前并没有发布作业！'
	'click signout_': !->
		Meteor.logout!
		Session.set 'haveLogin' false
}