<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
		
<title>로그인</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="/assets/css/tether.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
	<!-- 헤더 영역 -->
		<header>
			<c:import url="/sidenav" />
		</header>
				<!-- 아티클 영역 -->
	<article>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<h4>로그인 페이지</h4>
			<form action="${pageContext.request.contextPath}/login" method="post" class="form-inline center-align">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<div class="col s12">
					<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
						<p class="red-text">아이디 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요</p>
					</c:if>
				</div>
				<br>
				<div class="form-group">
					<input id="username" type="text" name="username"
						class="form-control" placeholder="아이디" value="" required>
				</div>
				<div class="form-group">
					<input id="password" type="password" name="password"
						class="form-control" placeholder="패스워드" value="" required>
				</div>
				<button type="submit"
					class="btn blue lighten-2 waves-effect waves-light z-depth-0">
					<i class="material-icons">power_settings_new</i>
				</button>
				<button type="button"
					class="btn red lighten-2 waves-effect waves-light z-depth-0"
					onclick="location.href='${pageContext.request.contextPath}/'">
					<i class="material-icons">close</i>
				</button>
				<p></p>
					<div class="flex-box">
			<a class="btn light-blue darken-2 waves-effect waves-light white-text btn-full z-depth-0" href="${pageContext.request.contextPath}/connect/facebook">페이스북 계정으로 이용하기</a> 
			<a class="btn amber lignten-1 waves-effect waves-light white-text btn-full z-depth-0" href="${pageContext.request.contextPath}/connect/kakao">카카오톡 계정으로 이용하기</a>
		</div>
			</form>
		</div>
	</div>
	</article>
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a>
				</div>
			
			<script	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
			<script type="text/javascript">
			$(".button-collapse").sideNav();
			
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
