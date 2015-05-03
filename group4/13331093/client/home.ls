Template['home'].helpers {
    currentuser: -> Session.get 'currentuser'
}

Template['home'].events {
	# 'click .sign-out': !-> Meteor.logout!
}
