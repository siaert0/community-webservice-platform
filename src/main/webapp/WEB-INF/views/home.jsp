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
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
		<link rel="stylesheet" href="/assets/css/tether.min.css">
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
					<div class="col s12">
						<span class="chip red lighten-2 white-text" style="border-radius:0; width:100%;">현재 개발 및 적용 현황은 다음과 같습니다.</span>
					</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="container">
					<div class="collection">
						<div class="collection-item">
							<p><b>시스템 구성</b></p>
							<p>Spring Boot 1.4.3</p>
							<p>Spring Security</p>
							<p>Spring Social Facebook, Kakao</p>
							<p>Spring Data JPA & Hibernate</p>
							<p>Spring Websocket - Sockjs - Stomp</p>
							<p>Lombok : Getter Setter</p>
							<p>ModelMapper : Object Mapping</p>
							<hr>
							<p><b>구현 및 적용 현황</b></p>
							<p>1. 회원가입 및 로그인 - Spring Security & Social(Facebook, Kakao)</p>
							<p>2. 회원정보 수정 및 탈퇴 - 탈퇴 시 모든 데이터 삭제</p>
							<p>3. 게시판 엔터티 및 페이징 기능 - JPA & AngularJS dirPagination</p>
							<p>4. 게시물 스크랩 및 추천 기능</p>
							<p>5. 게시판 에디터 적용 - Summernote</p>
							<p>6. 이미지 업로드 기능 - Summernote & Multipart</p>
							<p>7. 관리자 기능 부여 - 게시물 수정 및 삭제</p>
							<p>8. 관리자 기능 추가 - 회원 제재</p>
							<p>9. 게시물 단위 실시간 메시지 구독 - Spring Websocket & sockjs & stomp</p>
						</div>
					</div>
				</div>
			</div>
			<!-- 인증되지 않은 사용자의 메뉴 영역 -->
			<sec:authorize access="isAnonymous()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red waves-effect waves-light">
						<i class="material-icons">menu</i>
					</a>
					<ul>
					    <li><a class="btn-floating btn-large red waves-effect waves-light button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a></li>
						<li><a class="btn-floating blue btn-large waves-effect waves-light" href="${pageContext.request.contextPath}/login"><i class="material-icons">power</i></a></li>
					</ul>
				</div>
			</sec:authorize>
			
			<!-- 인증된 사용자의 메뉴 영역 -->
			<sec:authorize access="isAuthenticated()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red waves-effect waves-light">
						<i class="material-icons">menu</i>
					</a>
					<ul>
					    <li><a class="btn-floating waves-effect waves-light btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a></li>
						<li><a class="btn-floating waves-effect waves-light blue btn-large" href="/board/"><i class="material-icons">add</i></a></li>
					</ul>
				</div>
			</sec:authorize>
		</article>
		
		<!-- 푸터 영역 -->
		<footer class="page-footer white">
			<div class="footer-copyright">
				<div class="container center black-text">
					Bootstrap 4 & Materialize
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
