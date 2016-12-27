<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
<title>회원가입 페이지</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
<style>
header, article, footer {
		    padding-left: 0;
		}
</style>
</head>
<body>
<div class="valign-wrapper" style="width:100%; height:100%;">
	  <div class="valign center" style="margin:auto;">
      <form class="container col s12" onsubmit="false;">
      <input type="hidden"                        
		name="${_csrf.parameterName}"
		value="${_csrf.token}"/>
      <h5 class="center">회원가입 페이지[${userProfile.socialSignInProvider} 연동]</h5>
      <br>
      <div class="row left-align">
      <div class="col s12">
      <div class="col s3 m2">
      	<img class="responsive-img" src="${userProfile.thumbnail}"/>
      </div>
       <div class="input-field col s9 m5">
          <input id="id" name="id" type="text" class="validate" value="${userProfile.id}" readonly>
          <label for="id">식별번호</label>
        </div>
         <div class="input-field col s12 m5">
          <input id="nickname" type="text" class="validate" value="${userProfile.nickname}" readonly>
          <label for="nickname">이름</label>
        </div>
        </div>
        <div class="input-field col s8">
          <input id="email" name="email" type="email" class="validate">
          <label for="email">아이디(이메일)</label>
        </div>
        <div class="input-field col s4 right-align">
          <button type="button" class="btn" onclick="checkByEmail();">중복확인</button>
        </div>
        <div class="input-field col s12">
          <input id="password" type="password" class="validate">
          <label for="password">비밀번호</label>
        </div>
        <div class="input-field col s12">
			<div id="tag" class="chips chips-placeholder"></div>
		</div>
     </div>
         <div class="row right-align">
      <a class="waves-effect waves-light btn-flat" onclick="register()">회원가입 </a>
      <a class="waves-effect waves-light btn-flat" onclick="location.href='/login'">취소 </a>
       </div>
    </form>
    </div>
    </div>
    <!-- Compiled and minified JavaScript -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script type="text/javascript">
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	$(function() {
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(header, token);
		});
		$('.chips-placeholder').material_chip({
			secondaryPlaceholder : '+ 관심있는 분야'
		});
	});
	function checkByEmail(){

		if($('#email').val() == "" || $('#email').val() == null){
			$('#email').focus();
			return;
		}
		
		var dataObject =
		{
			email : $('#email').val()
		};
		
		$.ajax({
			type	: 'GET',
			url		: '/check/email',
			data	: dataObject,
			dataType	: 'JSON',
			success	: function(response){
				console.log("success",response);
				    alert("해당 이메일은 사용가능 합니다.");
			       isEmail = true;
			},
			error : function(response){
				console.log("error",response);
				alert("해당 이메일은 사용 중입니다.");
				$('#email').focus();
				isEmail = false;
	    		}
	    	});
	 }

	function register(){
		if(isEmail == false){
			alert("이메일 중복 확인을 하셔야 합니다.");
			return;
		}
		
		if($('#password').val() == "" || $('#password').val() == null){
			alert("패스워드를 반드시 입력해주세요.");
			$('#password').focus();
			return;
		}
		
		var chips = $('#tag').material_chip('data');
		var AuthObject = new Object(); 
		AuthObject.email = $('#email').val();
		AuthObject.password = $('#password').val();
		AuthObject.tags = JSON.stringify(chips);
		
		$.ajax({
			type	: 'POST',
			url		: '/user',
			data	: AuthObject,
			dataType	: 'JSON',
			success	: function(response){
				alert("회원가입 되었습니다.");
				location.href="/login"
			},
			error : function(response){
				console.log(response);
				
	    		}
	    	});
		
	}
</script>
</body>
</html>