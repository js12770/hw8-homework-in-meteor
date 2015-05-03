
if (Meteor.isClient) {
	Template.body.helpers({
		identity:function() {
			return Identity.findOne({owner : Meteor.userId()}).identity;
		},
		isTeacher:function() {
			return Identity.findOne({owner : Meteor.userId()}).identity == 'teacher';
		},
		user:function() {
			return Meteor.user().username;
		},
		homeworks:function() {
			return HomeWork.find({});
		},
		submits:function() {
			return Submits.find({});
		}
	});
}