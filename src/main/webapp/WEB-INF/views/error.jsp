<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html ng-app="myApp">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Community Webservice Platform</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tether.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body id="ErrorController" ng-controller="ErrorController" ng-cloak>
		<header>
<nav>
			    <div class="nav-wrapper blue lighten-1">
					<a class="brand-logo right waves-effect waves-light button-collapse hide-on-large-only blue lighten-1" data-activates="nav-mobile"><i class="material-icons">menu</i></a>
			      <ul class="list-none-style left">
			      <!-- 인증된 사용자의 메뉴 영역 -->
					<sec:authorize access="isAuthenticated()">
					    <li><a href="#">Community Webservice Platform</a></li>
					</sec:authorize>
					<sec:authorize access="isAnonymous()">
						 <li><a href="${pageContext.request.contextPath}/login">Community Webservice Platform</a></li>
					</sec:authorize>
			      </ul>
			    </div>
			  </nav>
			  <ul id="nav-mobile" class="side-nav fixed tabs-transparent">
    <li><div class="userView center">
      <div class="background blue lighten-1">
      </div>
      <sec:authorize access="isAnonymous()">
      	  <a href="#"><img class="circle" src="${pageContext.request.contextPath}/assets/img/user-star.png" style="margin:0 auto;"></a>
	      <a href="${pageContext.request.contextPath}/login"><span class="white-text name">로그인</span></a><br>
	  </sec:authorize>
      <sec:authorize access="isAuthenticated()">
      	  <a><img class="circle" src="${user.thumbnail}" style="margin:0 auto;"></a>
	      <a><span class="white-text name">${user.nickname}</span></a>
	      <form name="logoutform" action="${pageContext.request.contextPath}/logout"	method="post">
    		<input type="hidden"  name="${_csrf.parameterName}"	value="${_csrf.token}"/>
    	  </form>
	      <a href="#" onclick="logoutform.submit();"><span class="white-text email">로그아웃</span></a>
      </sec:authorize>
    </div></li>
    <li><a href="${pageContext.request.contextPath}/"><i class="material-icons">home</i>홈</a></li>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
    <li><a href="${pageContext.request.contextPath}/admin" class="waves-effect"><i class="material-icons">settings</i>관리페이지</a></li>
    </sec:authorize>
    <sec:authorize access="isAuthenticated()">
    <li><a href="${pageContext.request.contextPath}/user/${user.id}" class="waves-effect"><i class="material-icons">account_box</i>회원정보수정</a></li>
    <li><a href="${pageContext.request.contextPath}/board/scrap" class="waves-effect"><i class="material-icons">share</i>스크랩</a></li>
    <li><a href="${pageContext.request.contextPath}/board" class="waves-effect"><i class="material-icons">create</i>글쓰기</a></li>
    </sec:authorize>
    <li><div class="divider"></div></li>
    <li><a class="subheader">게시판</a></li>
    <!-- 게시판 카테고리 영역  -->
    <li ng-repeat="x in Categories"><a ng-href="${pageContext.request.contextPath}/board/category/{{x.name}}" class="waves-effect"><i class="material-icons">folder</i>{{x.name}}</a></li>
    <!--  -->
    <li><div class="divider"></div></li>
    <li><a class="subheader" class="waves-effect">IT 관련 사이트</a></li>
    <li><a href="http://stackoverflow.com/" target="_blank" class="waves-effect"><i class="material-icons">link</i>스택 오버플로우</a></li>
    <li><a href="http://okky.kr/" target="_blank" class="waves-effect"><i class="material-icons">link</i>OKKY</a></li>
    <li><a class="subheader">ETC</a></li>
    <li><a href="${pageContext.request.contextPath}/parse" class="waves-effect"><i class="material-icons">room</i>자바 에러 분석 기능</a></li>
    <li><a href="https://kdevkr.github.io/" target="_blank" class="waves-effect"><i class="material-icons">room</i>KDev Github Blog</a></li>
</ul>
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
			<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
			<script type="text/javascript">
			var contextPath = '${pageContext.request.contextPath}';
			var token = '${_csrf.token}';
			var header = '${_csrf.headerName}';
			$(function() {			
				$(document).ajaxSend(function(e, xhr, options) {
					xhr.setRequestHeader(header, token);
				});
				$(".button-collapse").sideNav();
			});
			
			var app = angular.module('myApp', []);

			app.controller('ErrorController', function($scope){
				$scope.loadCategory = function (){
					$.ajax({
						type	: 'GET',
						url		: contextPath+'/category',
						dataType	: 'JSON',
						success	: function(response){
							if(response != "" && response != null){
								$scope.$apply(function () {
									$scope.Categories = response;
								});
							}
						},
						error	: function(response){
							Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
								console.log(response);
							});
						}
					});
				}
				$scope.loadCategory();
			});
		</script>
</body>
</html>
