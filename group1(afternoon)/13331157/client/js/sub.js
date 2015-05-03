Template.sub.helpers({
	subs: function() {
		var id = Router.current().params.id;
		var homework = Homeworks.findOne({_id:id});
		return Submits.find({_homework:homework.title});
	},
	submits: function() {
		var id = Router.current().params.id;
		var homework = Homeworks.findOne({_id:id});
		return Submits.find({_homework:homework.title});
	}
});
