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
			 <nav>
			    <div class="nav-wrapper blue lighten-1">
					<a class="brand-logo right waves-effect waves-light button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">menu</i></a>
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
				<div class="row center-align">
				<p></p>
					<div class="col s12">
						<span class="chip teal lighten-2 white-text" style="border-radius:0; width:100%;">IT Stacks는 IT 신입 개발자들을 위한 공간입니다.</span>
					</div>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">
					<div class="col s12 l6">
						<span class="chip pink lighten-2 white-text" style="border-radius:0; width:100%;">최근 QA 소식</span>
						<div class="collection" style="border:0;">
							<div class="card sticky-action border-flat" ng-repeat="x in QATopList" ng-class="{selectedBoard:x.selected != 0, commentedBoard:x.selected == 0 && x.comments.length > 0}" style="margin:0; margin-top:5px;">
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
					
					<div class="col s12 l6">
						<span class="chip purple lighten-2 white-text" style="border-radius:0; width:100%;">최근 신입공채 소식</span>
						<div class="collection" style="border:0;">
							<div class="card sticky-action border-flat" ng-repeat="x in REQURITTopList"  ng-class="{selectedBoard:x.selected != 0, commentedBoard:x.selected == 0 && x.comments.length > 0}" style="margin:0; margin-top:5px;">
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
						
						<div class="col s12">
						<span class="chip deep-orange lighten-2 white-text" style="border-radius:0; width:100%;">최근 댓글 소식</span>
							
							<div class="collection">
								<div class="collection-item" ng-repeat="x in COMMENTTopList">
									<span class="chip transparent">
										<img ng-src="{{x.user.thumbnail}}" alt="Contact Person">
										    {{x.user.nickname}}
									</span>
									님이 <a class="teal-text hover" ng-href="/board/{{x.board}}">{{x.board}}번글</a>에 댓글을 달았습니다.
									<span class="chip transparent right">
										{{x.created | date:'yyyy년 MM월 dd일 h:mma'}}
									</span>
								</div>
							</div>
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
		<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
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
