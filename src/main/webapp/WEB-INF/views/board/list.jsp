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

				</div>
				<div class="row">
				<div class="col s12">
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${category} 에는 {{totalElements}}개의 게시물이 있습니다</span>
				</div>
					</div>
				<!-- 게시물 영역 -->
				<div class="row">
				<div class="col s12">
						<div class="collection" ng-if="totalElements > 0" style="border:0;">
						<form class="" style="margin-bottom: 0;" autocomplete="off" >
								<input id="search" type="text" placeholder="제목 및 태그로 검색가능" required class="form-control" ng-enter="searchKeywordChange()" ng-model="searchText" kr-input style="height:inherit; padding:1rem .75rem;">
						</form>
						</div>
				</div>
				<div dir-paginate="x in search_contents = (boardContents | orderBy:-index) | itemsPerPage:pagesize" pagination-id="boardpage" total-items="totalElements">
					<div class="col s12">
						<div class="card sticky-action border-flat" ng-class="{selectedBoard:x.selected != 0, commentedBoard:x.selected == 0 && x.comments.length > 0}" style="margin:0; margin-top:5px;">
							<div class="card-content" style="padding:10px; padding-top:15px;">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.user.thumbnail}}">
								   {{x.user.nickname}}
								  </span>
								  <span class="chip transparent teal-text border-flat left">	{{x.category}}</span>
								<span class="chip transparent blue-text border-flat left">댓글 {{x.comments.length}}</span>
								<span class="chip transparent red-text border-flat left">추천 {{x.thumbs.length}}</span>
								<span class="chip transparent black-text border-flat">{{x.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
								</div>
							<div class="card-content" style="padding-top:0;">
								<a class="hover-black hover" ng-href="/board/{{x.id}}" style="color:#444; font-weight:700; font-size:15px;">{{x.title}}</a>
							</div>
							<div class="card-action" style="padding:5px 10px;">
								<span class="tags" ng-init="tags=parseJson(x.tags)">
									<span ng-repeat="tag in tags"><span class="chip transparent red-text hover border-flat" style="margin:0;">{{tag}} </span>
								  </span>
								</span>
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
					<div class="row">
					<div class="col s12" ng-if="totalElements > 0">
					<p>관련 키워드로 검색하실 수 있습니다.</p>
							<span ng-repeat="tag in tagList">
								<span class="chip red lighten-2 white-text hover border-flat" style="">{{tag}} </span>
							</span>
					</div>
					</div>
			</div>
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
