<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>회원정보 수정 페이지</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tether.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
	<!-- 헤더 영역 -->
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
				<!-- 아티클 영역 -->
		<article>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<form class="container col s12" onsubmit="false;">
				<p></p>
				<h5 class="center"> 회원 정보 수정 페이지</h5>
				<br>
				<div class="row left-align">
					<div class="col s12">
						<div class="col s3 m2">
							<img class="responsive-img" src="${user.thumbnail}" style="width: 50px; height: 50px; padding-bottom: 15px;" />
						</div>
						<div class="input-field col s9 m5">
							<input id="id" name="id" type="text" class="form-control validate" value="${user.id}" readonly>
						</div>
						<div class="input-field col s12 m5">
							<input id="nickname" type="text" class="form-control validate" value="${user.nickname}">
						</div>
					</div>
					<div class="input-field col s12">
						<div class="input-group">
							<input id="email" name="email" type="email" class="form-control validate" placeholder="이메일 형식" value="${user.email}" readonly/> 
						</div>
					</div>
					<div class="input-field col s12">
						<input id="password" type="password" class="form-control validate" placeholder="비밀번호를 변경하실 경우에만 작성하세요">
					</div>
					<div class="input-field col s12"></div>
					<div class="input-field col s12">
						<div id="tag" class="tags form-control" data-tags-input-name="tag"></div>
					</div>
				</div>
				<div class="flex-box right-align">
					<a class="waves-effect waves-light btn blue lighten-2 white-text btn-full" onclick="userProfileUpdate()">수정하기 </a>
					   <c:if test="${user.role ne 'ROLE_ADMIN'}">
    
					<a class="waves-effect waves-light btn red lighten-2 white-text btn-full" onclick="withdraw(${user.id});">회원탈퇴 </a>
					</c:if>
				</div>
			</form>
		</div>
	</div>
	</article>

	<!-- Compiled and minified JavaScript -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
	<script type="text/javascript">
		var token = '${_csrf.token}';
		var header = '${_csrf.headerName}';
		$(function() {
			$(".button-collapse").sideNav();
			
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
			var tags = JSON.parse('${user.tags}');
			$('.tags').tagging("add",tags);
		});
		
		function userProfileUpdate() {
			var AuthObject = new Object();
			AuthObject.nickname = $('#nickname').val();
			if ($('#password').val() == "" || $('#password').val() == null)
				AuthObject.password = '${user.password}';
			else
				AuthObject.password = $('#password').val();
			
			AuthObject.tags = JSON.stringify($('#tag').tagging("getTags"));
			$.ajax({
				type : 'POST',
				url : '/user/'+$('#id').val(),
				data : AuthObject,
				dataType : 'JSON',
				success : function(response) {
					Materialize.toast("성공적으로 수정되었습니다 잠시후 페이지가 갱신됩니다",3000,'blue',function(){
						location.reload();
					});
					
				},
				error : function(response) {
					Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인부탁드립니다",3000,'red',function(){
						console.log(response);
					});
				}
			});
		}
	</script>
</body>
</html>