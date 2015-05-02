$(function() {
	$('#change-dialog').hide();
		function view(id) {
			$.post('/viewRequest',{id : id},function(data) {
				var data = eval('(' + data + ')');
				var request = data.request;
				$('#title').html(request.title);
				$('#content').html(request.content);
				$('#time').html(request.deadline);
				$('#x-id').val(request._id);
				$('#myModal').modal();
			})
		}

		$("#change").click(function() {
			$('#x-title').val($('#title').html());
			$('#x-content').val($('#content').html().replace(/<br>/g,'\n').replace(/&nbsp/g,' '));
			$('#x-time').val($('#time').html());
			$('#y-time').val($('#time').html());
			$('#view-dialog').hide();
			$('#change-dialog').show();
		})

		$('#myModal').on('hidden.bs.modal', function (e) {	
			$('#view-dialog').show();
			$('#change-dialog').hide();
		})

		$('#submit').click(function() {
			var content = $('#x-content').val();
			var time = $('#y-time').val();
			var title = $('#x-title').val();
			var id = $('#x-id').val();
			var postData = {
				content : content,
				deadline : time,
				title : title,
				id : id
			};
			console.log(postData);
			$.post('/createRequest',postData,function(data) {
				var data = eval('(' + data + ')');
				if(!!data.err) {
					alert(data.msg);
					window.location.href = '/home';
				}
				else {
					alert('修改作业要求成功!');
				}
			})
		})
})

