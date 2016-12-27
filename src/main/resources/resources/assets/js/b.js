function request_delete(url){
	$.ajax({
		type	: 'DELETE',
		url		: url,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 삭제되었습니다.", 3000);
			location.href="/"
		},
		error	: function(response){
			console.log(response);
			alert("오류가 발생하였습니다.", 3000);
		}
	});
}