Template['submitAssignmentList'].helpers {
    assignments: ->
        nd = new Date! .toISOString!.replace("T"," ")
        if Session.get('currentuser').identity is "teacher"
            myassi = myassignment.find!fetch!
        else
            myassi = myassignment.find {'username': Session.get('currentuser').firstName} .fetch!
        myassi.sort (a,b) !->
          if a['status'] == b['status']
            return  a['deadline'] >= b['deadline']
          else
            return a['status'] > b['status']
        for i in myassi
            i.overdl = if nd > i.deadline then true else false
            i.notgrade = if i.status is '已提交' then true else false
        return myassi
    isteacher: -> Session.get('currentuser').identity is "teacher"
}

Template['submitAssignmentList'].events {
    'click .view': (e)!->
        $ '.myAssignmentDetail' .remove-class 'hidden'
        $ '.assignment' .add-class 'hidden'
        $ '.submitAssignmentList' .add-class 'hidden'
        $ '.setassignment' .add-class 'hidden'
        Session.set 'myassignmentId', e.target.id
}
