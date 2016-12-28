<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<html ng-app="myApp" ng-clock>
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
	<body id="BoardController" ng-controller="BoardController">
	<!-- 헤더 영역 -->
		<header>
			<div class="navbar-fixed">
				<nav class="z-depth-0">
					<div class="nav-wrapper blue lighten-1">
						<form class="" style="margin-bottom: 0;" autocomplete="off">
							<div class="input-field">
								<input id="search" type="search" placeholder="키워드로 검색해보세요 ^ㅡ^" required ng-model="searchKeyword" kr-input>
								<label for="search"><i class="material-icons">search</i></label>
								<i class="material-icons">close</i>
							</div>
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
				<div class="row center-align">
				<p></p>
				<blockquote>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">사용자 등록수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${userCount}명</span>
					</div>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">전체 게시물수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${boardCount}개</span></div>
					<div class="col s12 m4 l4">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">현재 메모리 사용량</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${systemMemory}MB</span>
					</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">
				<div dir-paginate="x in search_contents = (boardContents | filter:searchKeyword | orderBy:-index) | itemsPerPage:pagesize" pagination-id="boardpage" total-items="totalElements">
					<div class="col s12">
						<div class="card sticky-action hoverable hover" data-ng-click="move(x.id)">
							<div class="card-image" style="padding:20px; padding-bottom:0;">
							    <span class="chip red lighten-2 hover white-text" style="border-radius:0; position:absolute; top:0; right:0; margin-right:0; padding-left:0;">
							    	<span class="chip blue lighten-2 hover white-text" data-ng-click="" style="border-radius:0; margin-right:10px;">답변 {{x.comments.length}}개</span>
							    	{{x.category}}
							    </span>
								<span style="font-weight:700; font-size:18px;">{{x.title}}</span>
							</div>
							<div class="card-content">
								<div class="justify-align">
									{{x.description}}
								</div>
							</div>
							<div class="card-action right-align">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.user.thumbnail}}">
								   {{x.user.nickname}}
								  </span>
								  <span class="tags" ng-init="chip=parseJson(x.tags)">
									<span ng-repeat="t in chip"><span class="chip red lighten-2 hover white-text" style="">{{t.tag}} </span>
								  </span>
								</span>
								<span class="chip grey darken-2 white-text">{{x.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
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
						    on-page-change="pageChange(newPageNumber)"
						    >
						</dir-pagination-controls>
					</div>
			</div>
			<!-- 인증되지 않은 사용자의 메뉴 영역 -->
			<sec:authorize access="isAnonymous()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"> <i class="material-icons">web</i>
					</a>
				</div>
			</sec:authorize>
			
			<!-- 인증된 사용자의 메뉴 영역 -->
			<sec:authorize access="isAuthenticated()">
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red"> <i class="material-icons">menu</i>
					</a>
					<ul>
						<li><a href="#" data-activates="nav-mobile" class="btn-floating btn-large red button-collapse hide-on-large-only"><i class="material-icons">web</i></a></li>
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
		<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
		<script	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
		<script	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
		<script	src="/assets/js/dirPagination.js"></script>
		<script src="/assets/js/app.js"></script>
		<script type="text/javascript">
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			$(function() {
				$(".dropdown-button").dropdown();
				$('.modal').modal();
				$('.chips-placeholder').material_chip({
					secondaryPlaceholder : '+ 태그'
				});
				$('.carousel').carousel();
				$('select').material_select();
				$(".button-collapse").sideNav();
				
				$(document).ajaxSend(function(e, xhr, options) {
					xhr.setRequestHeader(header, token);
				});		
			});
		</script>
	</body>
</html>
