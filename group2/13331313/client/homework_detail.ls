Template['homework_detail'].helpers {
  is-state: (arg)->
    return Session.equals 'currentState', arg

  homework:->
    return Session.get 'currentHw'

  answers:->
    if Meteor.user! .username == 'admin'
      return answers = Answers.find {hw_id: Session.get 'currentHw' ._id}
    else
      return answers = Answers.find {hw_id: Session.get 'currentHw' ._id, author: Meteor.user! .username}

  handinV:->
    D = new Date!
    Month = D.getMonth! + 1
    if Month < 10
      Month = '0' + Month
    time = D.getFullYear! + '-' + Month + '-' + D.getDate! + ' ' + D.getHours! + ':' + D.getMinutes!
    return time < Session.get 'currentHw' .deadline
}

Template['homework_detail'].events {
  'click .hw-list': (ev, tpl)!->
    ev.prevent-default!
    Session.set 'currentState', 'homePage'

  'click .edit-hw': (ev, tpl)!->
    ev.prevent-default!
    Session.set 'currentState', 'createHw'
    Session.set 'editState', 'change'

  'click .submit': (ev, tpl)!->
    ev.prevent-default!
    author = Meteor.user! .username
    content = ($ 'textarea[name=content]').val!
    unless content
      alert 'empty text not accepted'
    else
      answer = Answers.find-one {author: author, hw_id: Session.get 'currentHw' ._id}
      if answer
        Answers.update {_id: answer._id}, {content: content, author: author, hw_id: Session.get 'currentHw' ._id}
      else
        Answers.insert {content: content, author: author, hw_id: Session.get 'currentHw' ._id}

  'click .updateGrade': (ev, tpl)!->
    ev.prevent-default!
    ev.stopPropagation!
    grade = ev.target.parentElement.parentElement.lastChild.value
    Answers.update {_id: this._id}, {content: this.content, author: this.author, hw_id: this.hw_id, grade: grade}
}
