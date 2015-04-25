Template['teacherview'].helpers {
	requirment: !->
		therequirment =Homework.findOne {title:'onlyone'}
		if therequirment
			return therequirment.requirement
		else
			return '目前没有发布作业'
	deadline: !->
		thedeadline =Homework.findOne {title:'onlyone'}
		if thedeadline
			return thedeadline.deadline
		else
			return '无'
	deadlined: ->
		thehw = Homework.findOne {title:'onlyone'}
		thehw.getTime! < Date.now!
	assigns: -> Assignment.find!fetch!
}
Template['teacherview'].events {
	'click .givescores': !->
		scores = $ 'input[name='score_']'
		i = 0
		Assigns =  Assignment.find!fetch!
		[Assignment.update {name:assigns_.name}, {$set:{score:scores[i++].val!}} for assigns_ in Assigns]
	'click .createnewone': !->
		thehw = Homework.findOne {title:'onlyone'}
		if thehw
			Homework.update {title:'onlyone'}, {$set:{requirment:$ 'input[name = 'onlyrequirment']' .val!,deadline: $ 'input[name='onlydeadline']' .val!}}
			Meteor.call 'removeAll'
		else 
			Homework.insert {title:'onlyone',requirment:$ 'input[name = 'onlyrequirment']' .val!, deadline:new Date($ 'input[name='onlydeadline']' .val!)}
	'click modifyR': !->
		thehw = Homework.findOne {title:'onlyone'}
		if not deadlined and thehw
			Homework.update {title:'onlyone'}, {$set:{requirment:$ 'textarea[name = 'onlyrequirment']' .val!}}
		else
			alert '截止日期已过或未发布作业！'
	'click modifyD': !->
		thehw = Homework.findOne {title:'onlyone'}
		if not deadlined and thehw
			Homework.update {title:'onlyone'}, {$set:{deadline:new Date( $ 'input[name='onlydeadline']' .val!)}}
		else
			alert '截止日期已过或未发布作业！'
	'click signout_': !->
		Meteor.logout!
		Session.set 'haveLogin' false
}