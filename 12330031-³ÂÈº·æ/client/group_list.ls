Template['group_list'].helpers {
  groups: -> 
    groups = []
    students = Students.find!fetch!
    for student in students
      gid = parse-int student.group
      groups[gid] ||= []
      groups[gid].push student
    groups

  is-grouped: -> Students.findOne!?.group?
    
  ungroups: ->
    students = Students.find group: $exists: false

  get-group-index: (group)-> group[0].group + 1

  is-current: (student)->
    current-student = Session.get 'current-student'
    current-student and student.studentId is current-student.studentId
}