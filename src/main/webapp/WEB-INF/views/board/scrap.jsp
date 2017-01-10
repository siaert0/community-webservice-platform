<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<sec:authentication var="user" property="principal"/>
<html ng-app="myApp">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title>스프링 부트 웹 애플리케이션</title>

		<!--Import Google Icon Font-->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons"	rel="stylesheet">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
		<!-- Compiled and minified CSS -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
	</head>
	<body id="ScrapController" ng-controller="ScrapController" ng-cloak>
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
			<div class="container-fluid">
				<!-- 게시물 페이지네이션 영역 -->
				<div class="row left-align">
				<p></p>
				<blockquote>
					<div class="col s12">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">스크랩 수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">{{totalElements}}개</span>
						</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">		
				<div dir-paginate="x in search_contents = (scraps | filter:searchKeyword | orderBy:-index) | itemsPerPage:pagesize" pagination-id="scrappage" total-items="totalElements">
					<div class="col s12">
						<div class="card sticky-action hoverable border-flat" ng-class="{selectedBoard:x.board.selected != 0, commentedBoard:x.board.selected == 0 && x.board.comments.length > 0}">
							<div class="card-content">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.board.user.thumbnail}}">
								   {{x.board.user.nickname}}
								  </span>
								<span style="font-weight:700; font-size:18px;">{{x.board.title}}</span>
							</div>
							<div class="card-action right-align">
								<span class="chip teal lighten-2 hover white-text border-flat left">{{x.board.category}}</span>
							<span class="chip lighten-2 hover white-text border-flat left" ng-class="{blue:x.board.selected == 0 && x.board.comments.length > 0, grey:x.board.selected == 0 && x.board.comments.length == 0, green:x.board.selected != 0}">댓글 {{x.board.comments.length}}</span>
								<span class="chip lighten-2 hover white-text border-flat left" ng-class="{red:checkThumb({{x.board}})==0, green:checkThumb({{x.board}})==1, blue:checkThumb({{x.board}})==2}">추천 {{x.board.thumbs.length}}</span>
								<span class="chip green lighten-2 hover white-text border-flat" data-ng-click="move(x.board.id)">이동</span>
								<span class="chip red lighten-2 hover white-text border-flat" data-ng-click="scrap(x.board.id, $index)">스크랩 취소</span>
								
							</div>
						</div>
					</div>
					</div>
				</div>
				
				<!-- 게시물 페이지네이션 영역 -->
					<div class="center-align">
						<dir-pagination-controls
						    max-size="5"
						    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
						    direction-links="true"
	   						boundary-links="true"
						    pagination-id="scrappage"
						    on-page-change=""
						    >
						</dir-pagination-controls>
					</div>
			</div>
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
		<sec:authorize access="isAuthenticated()">
		<script>
		$(function() {
			var scope = angular.element(document.getElementById("ScrapController")).scope();
			scope.$apply(function(){
				scope.USERID = '${user.id}';
			});
		});
		</script>
		</sec:authorize>
		<script type="text/javascript">
		    var scrapUser = '${scrapUser}';
			var token = '${_csrf.token}';
			var header = '${_csrf.headerName}';
			$(function() {
				$(".button-collapse").sideNav();
				$(document).ajaxSend(function(e, xhr, options) {
					xhr.setRequestHeader(header, token);
				});
			});
		</script>
	</body>
</html>
