setFullScreen = ->
	$ '#homefull' .css 'height', (window.screen.availHeight-50-48-48)+'px'
Template['welcome'].on-rendered setFullScreen
Template['home'].on-rendered setFullScreen