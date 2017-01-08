<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>스프링 웹 애플리케이션</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="/assets/css/tether.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
		<header>
			<c:import url="/sidenav" />
		</header>
	<article>
		<div class="valign-wrapper" style="width: 100%; height: 100%;">
			<div class="valign center" style="margin: auto;">
			<h3>오류 안내</h3>
				<div class="collection">
					<div class="collection-item left-align">
						<!-- 
							스프링 부트 기본 오류 설정
							path
							status
							exception
							message
							errors
							trace
							timestamp
						 -->
						<c:if test="${empty exceptionResponse}">
							<h5>요청 경로 : ${path}</h5>
							<h5>HTTP 응답 코드 : ${status}</h5>
							<h5>오류 원인 : ${error}</h5>
							<h5>오류 발생 시각 : ${timestamp}</h5>
						</c:if>
						<!-- 
							커스텀 오류 설정
							path
							status
							exception
							error
							timestamp
						 -->
						<c:if test="${not empty exceptionResponse}">
							<h5>요청 경로 : ${exceptionResponse.path}</h5>
							<h5>HTTP 응답 코드 : ${exceptionResponse.status}</h5>
							<h5>오류 내용 : ${exceptionResponse.error}</h5>
							<h5>오류 발생 시각 : ${exceptionResponse.timestamp}</h5>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</article>
		<div class="fixed-action-btn click-to-toggle">
			<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile">
				<i class="material-icons">web</i>
			</a>
		</div>
			
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<!-- Compiled and minified JavaScript -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
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
