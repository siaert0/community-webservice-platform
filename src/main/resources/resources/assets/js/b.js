function scraping(){
	$('#s_title').val("");
	$('#s_image').val("");
	$('#s_description').val("");
	$('#s_img').attr("src","");
	$('#s_img').css("display","none");
	
	if($('#s_url').val() == "" || $('#s_url').val() == null){
		$('#s_url').focus();
		return;
	}
		
	
	var dataObject =
	{
		url : $('#s_url').val()
	};
	$.ajax({
		type	: 'GET',
		url		: '/information/scraping',
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
		    if(response.title == ""){
		    	Materialize.toast("웹 페이지 정보가 존재하지 않습니다.", 3000);
		    	$('#s_title').val("");
				$('#s_image').val("");
				$('#s_description').val("");
				$('#s_title').focus();
		    }else{
		    	$('#s_url').val(response.url);
				$('#s_title').val(response.title);
				$('#s_image').val(response.image);
				
				if(response.image == ""){
					
				}else{
					$('#s_img').attr("src",response.image);
					$('#s_img').css("display","block");
				}
				
				$('#s_description').val(response.description);
				Materialize.updateTextFields();
				Materialize.toast("웹 페이지 정보가 수집되었습니다.", 3000);
		    }
		},
		error : function(response){
			$('#s_title').val("");
			$('#s_image').val("");
			$('#s_description').val("");
			$('#s_url').focus();
			Materialize.toast("정상적인 URL이 아닙니다.", 3000);
		}
	});
}

function scrap_posting(){
	if($('#s_category').val() == "" || $('#s_category').val() == null){
		alert("카테고리를 선택하세요");
		return;
	}
		
	var scrapObject = new Object();
	scrapObject.url = $('#s_url').val();
	scrapObject.title = $('#s_title').val();
	scrapObject.category = $('#s_category').val();
	scrapObject.description = $('#s_description').val();
	var chips = $('#s_tag').material_chip('data');
	scrapObject.tags = JSON.stringify(chips);
	scrapObject.image = $('#s_image').val();
	var jsonObject = scrapObject;
	
	$.ajax({
		type	: 'POST',
		url		: '/board',
		data	: scrapObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 등록되었습니다.", 3000);
			location.reload();
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}

function comment_posting(){
	var commentObject = new Object();
	commentObject.board_index = $('#b_index').val();
	commentObject.description = $('#c_description').val();
	var chips = $('#c_tag').material_chip('data');
	commentObject.tags = JSON.stringify(chips);
	$.ajax({
		type	: 'POST',
		url		: '/comment',
		data	: commentObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 등록되었습니다.", 3000);
			getComment($('#b_index').val());
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}
function comment_update(){
	var commentObject = new Object();
	commentObject.index = $('#u_c_index').val();
	commentObject.description = $('#u_c_description').val();
	var chips = $('#u_c_tag').material_chip('data');
	commentObject.tags = JSON.stringify(chips);
	$.ajax({
		type	: 'POST',
		url		: '/comment/'+commentObject.index,
		data	: commentObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 수정되었습니다.", 3000);
			getComment($('#b_index').val());
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}
function comment_delete(){
	var commentObject = new Object();
	commentObject.index = $('#u_c_index').val();
	commentObject.description = $('#u_c_description').val();
	var chips = $('#u_c_tag').material_chip('data');
	commentObject.tags = JSON.stringify(chips);
	$.ajax({
		type	: 'DELETE',
		url		: '/comment/'+commentObject.index,
		data	: commentObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 삭제되었습니다.", 3000);
			getComment($('#b_index').val());
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}
function board_updating(){
	var boardObject = new Object();
	boardObject.index = $('#u_b_index').val();
	boardObject.title = $('#u_b_title').val();
	boardObject.description = $('#u_b_description').val();
	var chips = $('#u_b_tag').material_chip('data');
	boardObject.tags = JSON.stringify(chips);
	$.ajax({
		type	: 'POST',
		url		: '/board/'+boardObject.index,
		data	: boardObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 삭제되었습니다.", 3000);
			location.reload();
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}
function board_deleting(){
	var boardObject = new Object();
	boardObject.index = $('#u_b_index').val();
	boardObject.title = $('#u_b_title').val();
	boardObject.description = $('#u_b_description').val();
	var chips = $('#u_b_tag').material_chip('data');
	boardObject.tags = JSON.stringify(chips);
	$.ajax({
		type	: 'DELETE',
		url		: '/board/'+boardObject.index,
		data	: boardObject,
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 삭제되었습니다.", 3000);
			location.reload();
		},
		error	: function(response){
			Materialize.toast("오류가 발생하였습니다.", 3000);
		}
	});
}