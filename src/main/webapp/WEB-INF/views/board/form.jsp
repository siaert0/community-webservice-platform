<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html>
<head>
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>질문 폼 만들기</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
	
<!-- Compiled and minified JavaScript -->
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>

<link rel="stylesheet"	href="/assets/css/style.css">
</head>
<body>
	<div class="container">
	<div class="collection">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    ${user.nickname}
				</span>
			<div class="row">
			<div class="input-field col s12">
				<input id="q_title" name="q_title" type="text" />
				<label class="active" for="q_title">제목</label>
			</div>
			<div class="input-field col s12">
				<textarea id="q_content" name="q_content" class="materialize-textarea"></textarea>
				<label for="q_content">내용</label>
			</div>
			<div class="input-field col s12">
				<div id="q_tags" class="chips chips-placeholder"></div>
			</div>
			<div class="input-field col s12 right-align">
				<a class="waves-effect waves-light btn btn-flat" onclick="history.back();">뒤로가기</a>
				<a class="waves-effect waves-light btn btn-flat" onclick="board_post();"><i class="material-icons">send</i></a>
			</div>
		</div>
		</div>
	</div>
	</div>
	<div id="preloader" class="fixed-action-btn">
	<div class="preloader-wrapper active">
      <div class="spinner-layer spinner-blue">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-red">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-yellow">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-green">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>
    </div>
	</div>
<script type="text/javascript">
$(document).ready(function() {
	$('.chips-placeholder').material_chip({
	    placeholder: 'Enter a tag',
	    secondaryPlaceholder: 'Enter a tag',
	  });
	$('#preloader').hide();
  });
  
function board_post(){
	
	if($('#q_title').val() == "" || $('#q_title').val() == null){
		alert("제목을 작성하셔야 합니다.");
		return;
	}
	
	if($('#q_content').val() == "" || $('#q_content').val() == null){
		alert("내용을 작성하셔야 합니다.");
		return;
	}
	
	$('#preloader').show();	
	
	var boardObject = new Object();
	boardObject.category = "질문";
	boardObject.title = $('#q_title').val();
	boardObject.description = $('#q_content').val();
	var chips = $('#q_tags').material_chip('data');
	boardObject.tags = JSON.stringify(chips);
	
	$.ajax({
		type	: 'POST',
		url		: '/board',
		data	: JSON.stringify(boardObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 등록되었습니다.", 3000);
			console.log(response);
			location.href="/board/"+response.id;
		},
		error	: function(response){
			console.log(response);
			alert("오류가 발생하였습니다.");
		}
	});
	
	$('#preloader').hide();
}
</script>
<script>
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		$(function() {
			$(document).ajaxSend(function(e, xhr, options) {
				xhr.setRequestHeader(header, token);
			});
		});
	</script>
</body>
</html>