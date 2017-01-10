<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>스프링 부트 웹 애플리케이션</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<!-- include summernote css/js-->
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css" rel="stylesheet">
<link rel="stylesheet"  href="${pageContext.request.contextPath}/assets/css/tether.min.css">
<link rel="stylesheet"	href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
	<header>
				 <nav>
			    <div class="nav-wrapper blue lighten-1">
					<a class="brand-logo right waves-effect waves-light button-collapse hide-on-large-only blue lighten-1" data-activates="nav-mobile"><i class="material-icons">menu</i></a>
			      <ul class="list-none-style left">
			      <!-- 인증된 사용자의 메뉴 영역 -->
					<sec:authorize access="isAuthenticated()">
					    <li><a href="#">IT STACKS - 신입 개발자를 위한 질문 서비스</a></li>
					</sec:authorize>
					<sec:authorize access="isAnonymous()">
						 <li><a href="/login">IT STACKS를 이용하기 위해서는 로그인 하셔야 합니다.</a></li>
					</sec:authorize>
			      </ul>
			    </div>
			  </nav>
		<c:import url="/sidenav" />
	</header>
	<article>
	<div class="container">
	<div class="collection">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    ${user.nickname}
				</span>
			<div class="row">
			<div class="col s12">
				<select id="q_category" class="browser-default form-control">
			      <option value="" disabled selected>카테고리를 선택해주세요</option>
			      <option value="QA">QA</option>
			      <option value="신입공채">신입공채</option>
			    </select>
			</div>
			<div class="col s12"></div>
			<div class="input-field col s12">
				<b>제목</b>
				<input id="q_title" name="q_title" type="text" class="form-control" placeholder="제목을 입력해주세요" autofocus/>
			</div>
			<div class="col s12"></div>
			<div class="input-field col s12">
				<b>내용</b>
				<textarea id="q_content" name="q_content" class="form-control"></textarea>
			</div>
			<div class="col s12"></div>
			<div class="input-field col s12">
				<b>태그</b>
				<div data-tags-input-name="tag" id="q_tags" class="tags form-control"></div>
			</div>
			<div class="col s12"></div>
			<div class="input-field col s12 right-align">
				<a class="waves-effect waves-light btn btn-flat" onclick="history.back();">뒤로가기</a>
				<a class="waves-effect waves-light btn btn-flat" onclick="board_post();"><i class="material-icons">send</i></a>
			</div>
		</div>
		</div>
	</div>
	</div>
	</article>
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
	<!-- Compiled and minified JavaScript -->
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js" integrity="sha384-BLiI7JTZm+JWlgKa0M0kGRpJbF2J8q+qreVrKBC47e3K6BW78kGLrCkeRX6I9RoK" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/summernote-ko-KR.min.js"></script>
<script type="text/javascript">
<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
var token = '${_csrf.token}';
var header = '${_csrf.headerName}';

$(function() {
	$(".button-collapse").sideNav();
	$('.tags').tagging({
		"no-backspace": true,
		"no-duplicate": true,
	    "no-duplicate-callback": window.alert,
	    "no-duplicate-text": "태그 중복 방지 ->",
	    "forbidden-chars":[],
	    "forbidden-words":[],
		"no-spacebar":true,
		"tags-limit":8,
		"edit-on-delete":false
	});
	
	$('#q_content').summernote({   
		toolbar: [
		          // [groupName, [list of button]]
		          ['pre',['style']],
		          ['style', ['bold', 'italic', 'strikethrough', 'underline', 'clear']],
		          ['font', ['fontname','fontsize']],
		          ['color', ['color']],
		          ['para', ['paragraph'],['height']],
		          ['insert', ['link', 'picture', 'video']],
		          ['misc',['codeview']]
		        ],
		fontNames: ['Noto Sans KR', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
		fontNamesIgnoreCheck: ['Noto Sans KR'],
		lang: 'ko-KR',
		callbacks: {
		    onImageUpload: function(files) {
		    	for(var i=0; i<files.length; i++){
		    		sendImage(files[i], $(this));
		    	}
		      },
		    onMediaDelete: function(target){
		    	deleteImage(target[0].src);
		    }
		  }
	});
	$('#preloader').hide();
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(header, token);
	});
});
  
function board_post(){
	if($('#q_category').val() == "" || $('#q_category').val() == null){
		Materialize.toast("카테고리는 선택하셔야 합니다",3000,'orange',function(){
		});
		$('#q_category').focus();
		return;
	}
	
	if($('#q_title').val() == "" || $('#q_title').val() == null){
		Materialize.toast("제목을 작성하셔야 합니다",3000,'orange',function(){
		});
		$('#q_title').focus();
		return;
	}
	
	$('#preloader').show();	
	
	var boardObject = new Object();
	boardObject.category = $('#q_category').val();
	boardObject.title = $('#q_title').val();
	boardObject.description = $('#q_content').summernote('code');
	boardObject.tags = JSON.stringify($('#q_tags').tagging("getTags"));
	
	$.ajax({
		type	: 'POST',
		url		: '/board',
		data	: JSON.stringify(boardObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
 			Materialize.toast("정상적으로 등록되었습니다. 잠시후 이동됩니다.",3000,'green',function(){
 				location.href="/board/"+response.id;
			});
		},
		error	: function(response){
 			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
				console.log(response);
			});
		}
	});
	
	$('#preloader').hide();
}

function validation(fileName){
    var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1; //.뒤부터 확장자
    var fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex,fileName.length); //확장자 자르기
     
    if( !( (fileNameExtension=='jpg') || (fileNameExtension=='gif') || (fileNameExtension=='png') || (fileNameExtension=='bmp') ) ) {
			Materialize.toast("jpg, gif, png, bmp 확장자만 업로드 가능합니다.",3000,'red',function(){
				
			});
        return true;
    }
    else{
        return false;
    }
}

function sendImage(file, summernote){
	var data = new FormData();
      data.append("Filedata",file);
		$.ajax({
          type: 'POST',
          url: '/upload/image/',
          data: data,
        	contentType: false,
     		processData: false,
          dataType: 'JSON', //리턴되는 데이타 타입
          beforeSubmit: function(){
          },
          success: function(fileInfo){ //fileInfo는 이미지 정보를 리턴하는 객체
              if(fileInfo.result==-1){ //서버단에서 체크 후 수행됨
        			Materialize.toast("jpg, gif, png, bmp 확장자만 업로드 가능합니다.",3000,'red',function(){
        				console.log(response);
        			});
                  return false;
              }
              else if(fileInfo.result==-2){ //서버단에서 체크 후 수행됨
        			Materialize.toast("파일이 5MB를 초과하였습니다.",3000,'red',function(){
        				console.log(response);
        			});
                  return false;
              }
              else{
         			Materialize.toast("정상적으로 업로드되었습니다.",3000,'green',function(){
        				
        			});
            	  summernote.summernote('insertImage', fileInfo.imageurl, fileInfo.filename); 
              }
          }
      });
    }
    
function deleteImage(file){
	$.ajax({
      type: 'DELETE',
      url: '/upload/image/?url='+file,
      dataType: 'text', //리턴되는 데이타 타입
      beforeSubmit: function(){
      },
      success: function(response){
			Materialize.toast("정상적으로 삭제되었습니다.",3000,'green',function(){
				
			});
      },error: function(response){
  			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
				console.log(response);
			});
      }
  });
}
</script>
</body>
</html>