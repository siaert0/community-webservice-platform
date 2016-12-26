<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html ng-app="myApp" ng-clock>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<title>스프링 부트</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
<style type="text/css">
	header, article, footer{
		    padding-left: 300px;
		}
	.toolbar{
			z-index:999999;
		}
	@media only screen and (max-width: 992px){
		header, article, footer{
		    padding-left: 0;
		}
	}
</style>
</head>
<body  id="BoardController" ng-controller="BoardController">
<sec:authentication var="user" property="principal"/>
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
	<article>
		<div class="">
			<!-- Page Content goes here -->
			<div class="row center-align">
			<p></p>
			<blockquote>
			<div class="col s12 m4 l4"><span class="chip red lighten-2 hover white-text" style="border-radius:0;">사용자 등록수</span>
					<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${userCount}명</span></div>
					<div class="col s12 m4 l4"><span class="chip red lighten-2 hover white-text" style="border-radius:0;">전체 게시물수</span>
					<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${boardCount}개</span></div>
					<div class="col s12 m4 l4"><span class="chip red lighten-2 hover white-text" style="border-radius:0;">현재 메모리 사용량</span>
					<span class="chip grey darken-2 hover white-text" style="border-radius:0;">${systemMemory}MB</span></div>
			</blockquote>
			</div>
			<div class="container">
			</div>
			<div class="row">
			<p id="noContent" class="center-align"></p>
			<div dir-paginate="x in search_contents = (boardContents | filter:searchKeyword | orderBy:-index) | itemsPerPage:9" pagination-id="boardpage">
				<div class="col s12">
					<div class="card sticky-action hoverable hover" data-ng-click="move(x.id)">
						<div class="card-image" style="padding:20px; padding-bottom:0;">
						    <span class="chip red lighten-2 hover white-text" style="border-radius:0; position:absolute; top:0; right:0; margin-right:0; padding-left:0;"><span class="chip blue lighten-2 hover white-text" data-ng-click="" style="border-radius:0; margin-right:10px;">답변 {{x.comments.length}}개</span>{{x.category}}</span>
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
								<span ng-repeat="t in chip"><span class="chip red lighten-2 hover white-text" style="">{{t.tag}} </span></span>
							</span>
							
							 
						<span class="chip grey darken-2 white-text">{{x.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
						</div>
					</div>
				</div>
				</div>
			</div>
			<div class="row left-align">
				<div class="center-align">
				<dir-pagination-controls
					    max-size="5"
					    template-url="/assets/html/dirPagination.tpl.html"
					    direction-links="true"
   						boundary-links="true"
					    pagination-id="boardpage">
					    </dir-pagination-controls>
					
				</div>
			</div>
		</div>
		<sec:authorize access="isAnonymous()">
			<div class="fixed-action-btn click-to-toggle">
				<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"> <i class="material-icons">web</i>
				</a>
			</div>
		</sec:authorize>

		<sec:authorize access="isAuthenticated()">
			<div class="fixed-action-btn click-to-toggle">
				<a class="btn-floating btn-large red"> <i class="material-icons">menu</i>
				</a>
				<ul>
					<li><a href="#" data-activates="nav-mobile"
						class="btn-floating btn-large red button-collapse hide-on-large-only"><i
							class="material-icons">web</i></a></li>
					<li><a class="btn-floating blue btn-large" href="/board/"><i
							class="material-icons">add</i></a></li>
				</ul>

			</div>
		</sec:authorize>
	</article>
	<footer class="page-footer white">
		<div class="footer-copyright">
			<div class="container center black-text">
				© 2016 Copyright <a href="http://materializecss.com/"
					target="_blank">Materializecss</a> by <a
					href="https://material.io/">Google Material Design</a>.
			</div>
		</div>
	</footer>
	<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script type="text/javascript">
		window.onload = function() {
			$(".dropdown-button").dropdown();
			$('.modal').modal();
			$('.chips-placeholder').material_chip({
				secondaryPlaceholder : '+ 태그'
			});
			$('.carousel').carousel();
			$('select').material_select();
			$(".button-collapse").sideNav();
		};
		
		function open_modal() {
			$('#modal1').modal('open');
		}
</script>
	<script	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
	<script	src="/assets/js/dirPagination.js"></script>
	<!-- Compiled and minified JavaScript -->
	<script	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
	<script src="/assets/js/app.js"></script>
	<script>
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
