Meteor.startup -> 
	UploadServer.init {
		tmpDir: process.cwd! + '/../../../../../uploads/tmp',
		uploadDir: process.cwd! + '/../../../../../uploads/',
		checkCreateDirectoryies: true,
		finished: (fileInfo, formFields)!->
			if Homeworks.find-one {hwname: formFields.hwname, submits: {'$elemMatch': {'student' : formFields.student}}}
				(error) <- Homeworks.update {hwname:formFields.hwname}, {$push: {submits: {'student' : formFields.student, 'path' : (formFields.student+'.zip'), 'score' : '', date: new Date}}}
			else
				(error) <- Homeworks.update {hwname:formFields.hwname}, {$push: {submits: {'student' : formFields.student, 'path' : (formFields.student+'.zip'), 'score' : '', date: new Date}}}
	}