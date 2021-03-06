<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html ng-app="myApp">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>회원가입 페이지</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body id="RegisterController" ng-controller="RegisterController" ng-cloak>
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
						 <li><a href="${pageContext.request.contextPath}/login">IT STACKS를 이용하기 위해서는 로그인 하셔야 합니다.</a></li>
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
		<article>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<form class="container col s12" onsubmit="false;">
				<p></p>
				<h5 class="center">${userProfile.socialSignInProvider}로 이용하시겠어요?</h5>
				<br>
				<div class="row left-align">
					<div class="col-sm-12 center-align">
						<img class="responsive-img circle" src="${userProfile.thumbnail}" style="width: 50px;" />
						<p></p>
					</div>
					<div class="col-sm-6">
						<input id="id" name="id" type="text" class="form-control validate" value="${userProfile.id}" readonly>
						<p></p>
					</div>
					<div class="col-sm-6">
						<input id="nickname" type="text" class="form-control validate" value="${userProfile.nickname}" readonly>
						<p></p>
					</div>
					<div class="col-sm-12">
						<div class="input-group">
							<input id="email" name="email" type="email" class="form-control validate" placeholder="이메일 형식"/> 
							<span class="input-group-btn">
								<button class="waves-effect waves-light btn btn-flat teal lighten-2 white-text" type="button" onclick="checkByEmail();" id="checkByEmailBtn">중복확인</button>
							</span>
						</div>
						<p></p>
					</div>
					<div class="col-sm-12">
						<input id="password" type="password" class="form-control validate" placeholder="비밀번호(영문,숫자,특수문자로 이루어진 8자 이상 20자 이하)">
						<p></p>
					</div>
					<div class="col-sm-12">
						<div id="tag" class="tags form-control" data-tags-input-name="tag">태그</div>
					</div>
				</div>
				<div class="flex-box right-align">
					<a class="waves-effect waves-light btn blue lighten-2 white-text btn-full" onclick="register()">회원가입 </a>
					<a class="waves-effect waves-light btn red lighten-2 white-text btn-full" onclick="location.href='${pageContext.request.contextPath}/login'">취소 </a>
				</div>
			</form>
		</div>
	</div>
	</article>
	<!-- Compiled and minified JavaScript -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
		<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
	<script type="text/javascript">
	var contextPath = '${pageContext.request.contextPath}';
	var token = '${_csrf.token}';
	var header = '${_csrf.headerName}';
		$(function() {
			$(document).ajaxSend(function(e, xhr, options) {
				xhr.setRequestHeader(header, token);
			});
			
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
			$(".button-collapse").sideNav();
		});
		
		var isEmail = false;
		
		function checkByEmail() {
			if ($('#email').val() == "" || $('#email').val() == null) {
				alert("이메일을 입력해주세요");
				$('#email').focus();
				return;
			}
			
			var dataObject = {
				email : $('#email').val()
			};

			$.ajax({
				type : 'GET',
				url : contextPath+'/check/email',
				data : dataObject,
				dataType : 'JSON',
				success : function(response) {
					Materialize.toast("해당 이메일은 사용가능 합니다",3000,'green');
					$('#checkByEmailBtn').attr("disabled",true);
					$('#email').attr("readonly",true);
					isEmail = true;
				},
				error : function(response) {
					if(response.status == 400){ // 검증 오류 시
						Materialize.toast("이메일 형식이 아닙니다",3000,'orange',function(){
						});
					}else if(response.status == 406){ // 중복 오류 시
						Materialize.toast("해당 이메일은 이미 사용중 입니다",3000,'orange',function(){
						});
					}else{ // 이외의 오류
						Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
							console.log(response);
						});
					}
					$('#email').focus();
				}
			});
		}

		function register() {
			if (isEmail == false) {
	  			Materialize.toast("이메일 중복확인을 하셔야합니다",3000,'red',function(){
	
				});
				return;
			}
			if ($('#password').val() == "" || $('#password').val() == null) {
	  			Materialize.toast("패스워드를 입력해주세요 (8자 이상)",3000,'red',function(){
					
				});
				$('#password').focus();
				return;
			}
			var AuthObject = new Object();
			AuthObject.email = $('#email').val();
			AuthObject.password = $('#password').val();
			AuthObject.tags = JSON.stringify($('#tag').tagging("getTags"));
			$.ajax({
				type : 'POST',
				url : contextPath+'/user',
				data : AuthObject,
				dataType : 'JSON',
				success : function(response) {
		  			Materialize.toast("회원가입 되었습니다.",3000,'green',function(){
						
					});
		  			location.href=contextPath+"/";
				},
				error : function(response) {
					if(response.status == 400){
						Materialize.toast("비밀번호는 8자 이상, 20자 이하의 영문, 숫자, 특수문자로 이루어져야 합니다.",3000,'red',function(){
						});
					}else{
						Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
							console.log(response);
						});
					}
				}
			});
		}
		
		var app = angular.module('myApp', []);

		app.controller('RegisterController', function($scope){
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