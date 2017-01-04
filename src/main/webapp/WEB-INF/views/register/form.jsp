<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
<title>회원가입 페이지</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tether.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
header, article, footer {
	padding-left: 0;
}
</style>
</head>
<body>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<form class="container col s12" onsubmit="false;">
				<p></p>
				<h5 class="center">회원가입 페이지[${userProfile.socialSignInProvider}연동]</h5>
				<br>
				<div class="row left-align">
					<div class="col s12">
						<div class="col s3 m2">
							<img class="responsive-img" src="${userProfile.thumbnail}" style="width: 50px; height: 50px; padding-bottom: 15px;" />
						</div>
						<div class="input-field col s9 m5">
							<input id="id" name="id" type="text" class="form-control validate" value="${userProfile.id}" readonly>
						</div>
						<div class="input-field col s12 m5">
							<input id="nickname" type="text" class="form-control validate" value="${userProfile.nickname}" readonly>
						</div>
					</div>
					<div class="input-field col s12">
						<div class="input-group">
							<input id="email" name="email" type="email" class="form-control validate" placeholder="이메일 형식"/> 
							<span class="input-group-btn">
								<button class="waves-effect waves-light btn btn-flat teal lighten-2 white-text" type="button" onclick="checkByEmail();">중복확인</button>
							</span>
						</div>
					</div>
					<div class="input-field col s12">
						<input id="password" type="password" class="form-control validate" placeholder="비밀번호(8자이상)">
					</div>
					<div class="input-field col s12"></div>
					<div class="input-field col s12">
						<div id="tag" class="tags form-control" data-tags-input-name="tag"></div>
					</div>
				</div>
				<div class="flex-box right-align">
					<a class="waves-effect waves-light btn blue lighten-2 white-text btn-full" onclick="register()">회원가입 </a>
					<a class="waves-effect waves-light btn red lighten-2 white-text btn-full" onclick="location.href='${pageContext.request.contextPath}/login'">취소 </a>
				</div>
			</form>
		</div>
	</div>
	<!-- Compiled and minified JavaScript -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
	<script type="text/javascript">
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		$(function() {
			$(document).ajaxSend(function(e, xhr, options) {
				xhr.setRequestHeader(header, token);
			});
			
			$('.tags').tagging({
				"no-backspace" : true,
				"no-duplicate" : true,
				"no-duplicate-callback" : window.alert,
				"no-duplicate-text" : "태그 중복 방지 ->",
				"forbidden-chars" : [],
				"forbidden-words" : [],
				"no-spacebar" : true,
				"tags-limit" : 8,
				"edit-on-delete" : false
			});
		});
		
		var isEmail = false;
		function checkByEmail() {
			if ($('#email').val() == "" || $('#email').val() == null) {
				alert("이메일을 입력해주세요");
				$('#email').focus();
				return;
			}
			var dataObject = {
				email : $('#email').val()
			};

			$.ajax({
				type : 'GET',
				url : '/check/email',
				data : dataObject,
				dataType : 'JSON',
				success : function(response) {
					console.log("success", response);
					alert("해당 이메일은 사용가능 합니다.");
					isEmail = true;
				},
				error : function(response) {
					console.log("error", response);
					alert("해당 이메일은 사용 중입니다.");
					$('#email').focus();
					isEmail = false;
				}
			});
		}

		function register() {
			if (isEmail == false) {
				alert("이메일 중복 확인을 하셔야 합니다.");
				return;
			}
			if ($('#password').val() == "" || $('#password').val() == null) {
				alert("패스워드를 반드시 입력해주세요.");
				$('#password').focus();
				return;
			}
			var AuthObject = new Object();
			AuthObject.email = $('#email').val();
			AuthObject.password = $('#password').val();
			AuthObject.tags = JSON.stringify($('#tag').tagging("getTags"));
			$.ajax({
				type : 'POST',
				url : '/user',
				data : AuthObject,
				dataType : 'JSON',
				success : function(response) {
					alert("회원가입 되었습니다.");
					location.href = "${pageContext.request.contextPath}/login"
				},
				error : function(response) {
					console.log(response);
					alert("이메일 형식과 비밀번호 4자리 이상 입력해주세요");
				}
			});
		}
	</script>
</body>
</html>