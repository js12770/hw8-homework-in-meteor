#之后可删除

if Homeworks.find().count() is 0
	Homeworks.insert
		name: 'lalala'
		teacher: 't 1'
		description: "崩溃..."
		start: '2015-04-25'
		ddl: '2015-04-28'

	Homeworks.insert
		name: 'second'
		teacher: 't 1'
		description: "求心理阴影面积"
		start: '2015-04-23'
		ddl: '2015-04-24'
