<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<html ng-app="myApp">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		
		<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
		<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
		<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />

		<title>스프링 부트 웹 애플리케이션</title>

		<!--Import Google Icon Font-->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons"	rel="stylesheet">
		<!-- Compiled and minified CSS -->
		<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
		<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
		<link rel="stylesheet" href="/assets/css/style.css">
	</head>
	<body id="HomeController" ng-controller="HomeController" ng-cloak>
	<!-- 헤더 영역 -->
		<header>
			<c:import url="/sidenav" />
		</header>
		<!-- 아티클 영역 -->
		<article>
			<div class="container-fluid">
				<!-- 게시물 페이지네이션 영역 -->
				<div class="row center-align">
				<p></p>
				<blockquote>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">사용자 등록수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${userCount}명</span>
					</div>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">뭘 표시할까..</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">NONE</span></div>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">현재 메모리 사용량</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${systemMemory}MB</span>
					</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="container">
					<div class="collection">
						<div class="collection-item">
							<p>Spring Boot 1.4.3</p>
							<p>Spring Security [적용완료]</p>
							<p>Spring Social [페이스북, 카카오]</p>
							<p>Spring Data JPA & Hibernate</p>
							<p>Spring Websocket - Sockjs - Stomp</p>
							<p>Lombok - 유튜브 백기선님 동영상 참고</p>
							<p>ModelMapper - 유튜브 백기선님 동영상 참고</p>
						</div>
					</div>
				</div>
			</div>
			<!-- 인증되지 않은 사용자의 메뉴 영역 -->
			<sec:authorize access="isAnonymous()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red">
						<i class="material-icons">menu</i>
					</a>
					<ul>
					    <li><a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a></li>
						<li><a class="btn-floating blue btn-large" href="${pageContext.request.contextPath}/login"><i class="material-icons">power</i></a></li>
					</ul>
				</div>
			</sec:authorize>
			
			<!-- 인증된 사용자의 메뉴 영역 -->
			<sec:authorize access="isAuthenticated()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red">
						<i class="material-icons">menu</i>
					</a>
					<ul>
					    <li><a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a></li>
						<li><a class="btn-floating blue btn-large" href="/board/"><i class="material-icons">add</i></a></li>
					</ul>
				</div>
			</sec:authorize>
		</article>
		
		<!-- 푸터 영역 -->
		<footer class="page-footer white">
			<div class="footer-copyright">
				<div class="container center black-text">
					© 2016 Copyright <a href="http://materializecss.com/"
						target="_blank">Materializecss</a> by <a
						href="https://material.io/">Google Material Design</a>.
				</div>
			</div>
		</footer>

		<!-- Compiled and minified JavaScript -->
		
		<script	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
		
		<script	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
		<script	src="https://code.angularjs.org/1.5.7/angular-sanitize.js"></script>
		<script	src="/assets/js/dirPagination.js"></script>
		<script src="/assets/js/app.js"></script>
		<script type="text/javascript">
			var category = "${category}";
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
