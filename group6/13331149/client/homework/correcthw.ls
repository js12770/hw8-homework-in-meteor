Template.correcthw.helpers {
  uploads: ->
    console.log Homeworks.find-one {hwname:this.hwname}
    Homeworks.find-one {hwname:this.hwname}
}

Template.correcthw.events {
  'submit form': (events)->
    event.preventDefault!
    scores = events.target.score
    for score, i in scores
      (error) <-Homeworks.update {_id:(Homeworks.find-one {hwname: this.hwname})['_id']}, {$set: {('submits.'+ i.to-string!+'.score') : score.value}}
      console.log "Error in submit score: ", error if error
    return 
}