
if (Meteor.isClient) {
	Template.submit.events({
		"change #grade":function(event) {
			Submits.update(this._id, {$set:{grade:event.target.value}});
			console.log(event.target.value);
			return false;
		},
		"click .delete": function () {
			Submits.remove(this._id);
		}
	});

	Template.submit.helpers({
		isTeacher:function() {
			return Identity.findOne({owner : Meteor.userId()}).identity == 'teacher';
		},
	});
}