<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html>
<head>
<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>게시물 작성하기</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" integrity="sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi" crossorigin="anonymous">

<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<!-- include summernote css/js-->

<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css" rel="stylesheet">
<link rel="stylesheet"  href="/assets/css/tether.min.css">
<link rel="stylesheet"  href="/assets/css/tag-basic-style.css">
<link rel="stylesheet"	href="/assets/css/style.css">
</head>
<body>
	<header>
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
				<select id="q_category" class="browser-default">
			      <option value="" disabled selected>카테고리를 선택해주세요</option>
			      <option value="질문">질문</option>
			      <option value="정보">정보</option>
			    </select>
			</div>
			<div class="input-field col s12">
				<input id="q_title" name="q_title" type="text" autofocus/>
				<label class="active" for="q_title">제목</label>
			</div>
			<div class="input-field col s12">
				<textarea id="q_content" name="q_content" class="materialize-textarea"></textarea>
			</div>
			<div class="input-field col s12">
				<div data-tags-input-name="tag" id="q_tags" class="tags">지우고 태그를 작성하세요</div>
			</div>
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
<script src="/assets/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js" integrity="sha384-BLiI7JTZm+JWlgKa0M0kGRpJbF2J8q+qreVrKBC47e3K6BW78kGLrCkeRX6I9RoK" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="/assets/js/tagging.js"></script>
<script src="/assets/js/lib/src-noconflict/ace.js"></script>
<script src="/assets/js/summernote-ace-plugin.js"></script>
<script src="/assets/js/summernote-ko-KR.min.js"></script>
<script type="text/javascript">
var token = $("meta[name='_csrf']").attr("content");
var header = $("meta[name='_csrf_header']").attr("content");

$(function() {
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
	
    var codeblockButton = function (context) {
        var ui = $.summernote.ui;
  
        // create button
        var button = ui.button({
            contents: '코드',
            tooltip: '코드',
            click: function () {
    
                $('#q_content').summernote('code', '<p><br></p><p><pre><code>코드 붙여넣기</code></pre></p><p><br></p>');
    }
  });

  return button.render();   // return button as jquery object 
}
	
	$('#q_content').summernote({   
		toolbar: [
		          // [groupName, [list of button]]
		          ['pre',['style']],
		          ['style', ['bold', 'italic', 'strikethrough', 'underline', 'clear']],
		          ['font', ['fontname','fontsize']],
		          ['color', ['color']],
		          ['para', ['paragraph'],['height']],
		          ['insert', ['link', 'picture', 'video']],
		          ['misc',['codeblock','codeview']]
		        ],
		fontNames: ['Noto Sans KR', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
		fontNamesIgnoreCheck: ['Noto Sans KR'],
		lang: 'ko-KR',
		callbacks: {
		    onImageUpload: function(files) {
		    	sendImage(files[0],this);
		      },
		    onMediaDelete: function(target){
		    	deleteImage(target[0].src);
		    }
		  },
		  buttons: {
              codeblock: codeblockButton
          }
	});
	$('select').material_select();
	$('#preloader').hide();
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(header, token);
	});
});
  
function board_post(){
	if($('#q_category').val() == "" || $('#q_category').val() == null){
		alert("카테고리를 선택하셔야 합니다.");
		return;
	}
	
	if($('#q_title').val() == "" || $('#q_title').val() == null){
		alert("제목을 작성하셔야 합니다.");
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

function validation(fileName){
    var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1; //.뒤부터 확장자
    var fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex,fileName.length); //확장자 자르기
     
    if( !( (fileNameExtension=='jpg') || (fileNameExtension=='gif') || (fileNameExtension=='png') || (fileNameExtension=='bmp') ) ) {
        alert('jpg, gif, png, bmp 확장자만 업로드 가능합니다.');
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
                  alert('jpg, gif, png, bmp 확장자만 업로드 가능합니다.');
                  return false;
              }
              else if(fileInfo.result==-2){ //서버단에서 체크 후 수행됨
                  alert('파일이 5MB를 초과하였습니다.');
                  return false;
              }
              else{
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
    	  Materialize.toast("정상적으로 삭제되었습니다.", 3000);
      }
  });
}
</script>
</body>
</html>