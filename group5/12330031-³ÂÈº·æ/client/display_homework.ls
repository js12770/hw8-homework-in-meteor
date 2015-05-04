Template['display_homework'].helpers {
  homeworks: ->
    homeworks = Homeworks.find!fetch!
    homeworks
}
Template['display_homework'].events {
  'click .homework': !->
    console.log this
    id = this['_id']
    ($ '#detail input[name=_id]').val(id)
}
