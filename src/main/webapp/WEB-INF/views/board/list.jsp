<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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
		<link rel="stylesheet"  href="${pageContext.request.contextPath}/assets/css/style.css">
	</head>
	<body id="BoardController" ng-controller="BoardController" ng-cloak>
	<!-- 헤더 영역 -->
		<header>
			<div class="navbar-fixed">
				<nav class="z-depth-0">
					<div class="nav-wrapper blue lighten-1">
						<form class="" style="margin-bottom: 0;" autocomplete="off" >
								<input id="search" type="search" placeholder="제목 및 태그로 검색가능" required class="form-control" ng-enter="searchKeywordChange()" ng-model="searchText" kr-input style="height:inherit; padding:0rem .75rem;">
						</form>
					</div>
				</nav>
			</div>
			<c:import url="/sidenav" />
		</header>
		<!-- 아티클 영역 -->
		<article>
			<div class="container-fluid">
				<!-- 게시물 페이지네이션 영역 -->
				<div class="row left-align">
				<p></p>
				<blockquote>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">${category} 게시물수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">{{totalElements}}개</span>
						</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">
				<div dir-paginate="x in search_contents = (boardContents | orderBy:-index) | itemsPerPage:pagesize" pagination-id="boardpage" total-items="totalElements">
					<div class="col s12">
						<div class="card sticky-action hoverable hover border-flat" data-ng-click="move(x.id)" ng-class="{selectedBoard:x.selected != 0, commentedBoard:x.selected == 0 && x.comments.length > 0}" style="margin:0;">
							<div class="card-content">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.user.thumbnail}}">
								   {{x.user.nickname}}
								  </span>
								<span style="font-weight:700; font-size:18px;">{{x.title}}</span>
							</div>
							<div class="card-action right-align">
								<span class="chip teal lighten-2 hover white-text border-flat left">	{{x.category}}</span>
							<span class="chip lighten-2 hover white-text border-flat left" ng-class="{blue:x.selected == 0 && x.comments.length > 0, red:x.selected == 0 && x.comments.length == 0, green:x.selected != 0}">댓글 {{x.comments.length}}</span>
								  <span class="chip lighten-2 hover white-text border-flat left" ng-class="{red:checkThumb({{x}})==0, green:checkThumb({{x}})==1, blue:checkThumb({{x}})==2}">추천 {{x.thumbs.length}}</span>
								  <span class="tags" ng-init="tags=parseJson(x.tags)">
									<span ng-repeat="tag in tags"><span class="chip red lighten-2 hover white-text border-flat" style="">{{tag}} </span>
								  </span>
								</span>
								<span class="chip grey darken-2 white-text border-flat">{{x.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
							</div>
						</div>
					</div>
					</div>
				</div>
				
				<!-- 게시물 페이지네이션 영역 -->
					<div class="center-align">
						<dir-pagination-controls
						    max-size="5"
						    template-url="/assets/html/dirPagination.tpl.html"
						    direction-links="true"
	   						boundary-links="true"
						    pagination-id="boardpage"
						    on-page-change=""
						    >
						</dir-pagination-controls>
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
						<li><a class="btn-floating blue waves-effect waves-light btn-large" href="${pageContext.request.contextPath}/login"><i class="material-icons">power</i></a></li>
					</ul>
				</div>
			</sec:authorize>
			
			<!-- 인증된 사용자의 메뉴 영역 -->
			<sec:authorize access="isAuthenticated()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red waves-effect waves-light" > <i class="material-icons">menu</i>
					</a>
					<ul>
						<li><a href="#" data-activates="nav-mobile" class="btn-floating btn-large red waves-effect waves-light button-collapse hide-on-large-only"><i class="material-icons">web</i></a></li>
						<li><a class="btn-floating blue btn-large waves-effect waves-light" href="/board/"><i class="material-icons">add</i></a></li>
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
			var category = "${category}";
			var token = '${_csrf.token}';
			var header = '${_csrf.headerName}';
			
			$(function() {
				$(".button-collapse").sideNav();
				$(document).ajaxSend(function(e, xhr, options) {
					xhr.setRequestHeader(header, token);
				});
				
			});
		</script>
		<sec:authorize access="isAuthenticated()">
		<script>
		$(function() {
			var scope = angular.element(document.getElementById("BoardController")).scope();
			scope.$apply(function(){
				scope.USERID = '${user.id}';
			});
		});
		</script>
		</sec:authorize>
	</body>
</html>
