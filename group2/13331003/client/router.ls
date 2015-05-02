hide = (selector)!-> $ selector .add-class 'hide'
show = (selector)!-> $ selector .remove-class 'hide'

hide-homepage = !->
  hide '#assignmentList'
  hide '#homeworkList'

show-homepage = !->
  show '#assignmentList'
  show '#homeworkList'

hide-others = !->
  other-pages = <[#publish #modify #submit]>

  for page in other-pages
    unless $ page .has-class 'hide' then hide page

Template['body'].events {
  'click .publish-button': !->
    hide-homepage!
    show '#publish'

  'click .modify-button': !->
    hide-homepage!
    show '#modify'

  'click .submit-button': !->
    hide-homepage!
    show '#submit'

  'click .homepage-button': !->
    hide-others!
    show-homepage!
}