<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html ng-app="myApp">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Community Webservice Platform</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body id="UserController" ng-controller="UserController" ng-cloak>
	<!-- 헤더 영역 -->
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
    <li><a href="https://kdevkr.github.io/" target="_blank" class="waves-effect"><i class="material-icons">room</i>KDev Github Blog</a></li>
</ul>
		</header>
				<!-- 아티클 영역 -->
		<article>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<form class="container-fluid" onsubmit="false;">
				<p></p>
				<h5 class="center"><img class="responsive-img" src="${user.thumbnail}" /></h5>
				<br>
				<div class="row left-align">
						<div class="col-sm-6">
							<b>회원번호</b>
							<input id="id" name="id" type="text" class="form-control validate" value="${user.id}" readonly>
							<p></p>
						</div>
						<div class="col-sm-6">
							<b>회원이름</b>
							<input id="nickname" type="text" class="form-control validate" value="${user.nickname}">
							<p></p>
						</div>
					<div class="col-sm-12">
						<b>회원이메일</b>
							<input id="email" name="email" type="email" class="form-control validate" placeholder="이메일 형식" value="${user.email}" readonly/> 
						<p></p>
					</div>
					<div class="col-sm-12">
						<b>비밀번호</b>
						<input id="password" type="password" class="form-control validate" placeholder="원래의 비밀번호 또는 새로운 비밀번호를 입력하세요">
						<p></p>
					</div>
					<div class="col-sm-12">
					<b>태그</b>
						<div id="tag" class="tags form-control" data-tags-input-name="tag"></div>
					<p></p>
					</div>
				</div>
				<div class="flex-box right-align">
					<a class="btn blue lighten-2 white-text waves-effect waves-light btn-full" onclick="userProfileUpdate()">수정하기 </a>
					   <c:if test="${user.role ne 'ROLE_ADMIN'}">
    
					<a class="btn red lighten-2 white-text waves-effect waves-light btn-full" onclick="withdraw(${user.id});">회원탈퇴 </a>
					</c:if>
				</div>
			</form>
		</div>
	</div>
	</article>

<!-- Compiled and minified JavaScript -->		
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/lang/summernote-ko-KR.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
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

function withdraw(id){
	if(!confirm("정말로 탈퇴하시겠습니까?"))
		return;
	
	$.ajax({
		type	: 'DELETE',
		url		: contextPath+'/user/'+id,
		success	: function(response){
			Materialize.toast("정상적으로 탈퇴되었습니다.", 3000);
			location.href=contextPath+"/";
		},
		error	: function(response){
			console.log(response);
			Materialize.toast("탈퇴하지 못했습니다", 3000);
		}
	});
}

		$(function() {
			$('.tags').tagging({
				"no-backspace" : true,
				"no-duplicate" : true,
				"no-duplicate-callback" : window.alert,
				"no-duplicate-text" : "태그 중복 방지 ->",
				"forbidden-chars" : [],
				"forbidden-words" : [],
				"no-spacebar" : true,
				"tags-limit" : 8,
				"edit-on-delete" : false
			});
			var usertags = '${user.tags}';
			var tags = null;
			if(usertags != "")
				tags = JSON.parse(usertags);
			$('.tags').tagging("add",tags);
		});
		
		function userProfileUpdate() {
			var AuthObject = new Object();
			AuthObject.nickname = $('#nickname').val();
			AuthObject.password = $('#password').val();
			
			AuthObject.tags = JSON.stringify($('#tag').tagging("getTags"));
			$.ajax({
				type : 'POST',
				url : contextPath+'/user/'+$('#id').val(),
				data : AuthObject,
				dataType : 'JSON',
				success : function(response) {
					Materialize.toast("성공적으로 수정되었습니다 잠시후 페이지가 갱신됩니다",3000,'blue',function(){
						location.reload();
					});
					
				},
				error : function(response) {
					Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인부탁드립니다",3000,'red',function(){
						console.log(response);
					});
				}
			});
		}
		
		var app = angular.module('myApp', []);

		app.controller('UserController', function($scope){
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