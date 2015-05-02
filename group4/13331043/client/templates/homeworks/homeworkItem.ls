Template.homework-item.events {
  'submit form': (e)->
    e.preventDefault!

    input = ($ e.target) .find '[name=grade]'
    _id = input[0].id

    grade = ($ e.target) .find '[name=grade]' .val!
    Homework.update _id, {$set: {grade: grade}}
}