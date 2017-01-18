<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
		
<title>Community Webservice Platform</title>
<link rel="stylesheet" href="http://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
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
						 <li><a href="/login">Community Webservice Platform</a></li>
					</sec:authorize>
			      </ul>
			    </div>
			  </nav>
			  <ul id="nav-mobile" class="side-nav fixed tabs-transparent">
    <li><div class="userView center">
      <div class="background blue lighten-1">
      </div>
      <sec:authorize access="isAnonymous()">
      	  <a href="#"><img class="circle" src="/assets/img/user-star.png" style="margin:0 auto;"></a>
	      <a href="${pageContext.request.contextPath}/login"><span class="white-text name">로그인</span></a><br>
	  </sec:authorize>
      <sec:authorize access="isAuthenticated()">
      	  <a><img class="circle" src="${user.thumbnail}" style="margin:0 auto;"></a>
	      <a><span class="white-text name">${user.nickname}</span></a>
	      <form name="logoutform" action="/logout"	method="post">
    		<input type="hidden"  name="${_csrf.parameterName}"	value="${_csrf.token}"/>
    	  </form>
	      <a href="#" onclick="logoutform.submit();"><span class="white-text email">로그아웃</span></a>
      </sec:authorize>
    </div></li>
    <li><a href="/"><i class="material-icons">home</i>홈</a></li>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
    <li><a href="/admin" class="waves-effect"><i class="material-icons">settings</i>관리페이지</a></li>
    </sec:authorize>
    <sec:authorize access="isAuthenticated()">
    <li><a href="/user/${user.id}" class="waves-effect"><i class="material-icons">account_box</i>회원정보수정</a></li>
    <li><a href="/board/scrap" class="waves-effect"><i class="material-icons">share</i>스크랩</a></li>
    <li><a href="/board" class="waves-effect"><i class="material-icons">create</i>글쓰기</a></li>
    </sec:authorize>
    <li><div class="divider"></div></li>
    <li><a class="subheader">게시판</a></li>
    <!-- 게시판 카테고리 영역  -->
    <li><a href="/board/category/QA" class="waves-effect"><i class="material-icons">folder</i>QA</a></li>
    <li><a href="/board/category/Information" class="waves-effect"><i class="material-icons">folder</i>Information</a></li>
    <!--  -->
    <li><div class="divider"></div></li>
    <li><a class="subheader" class="waves-effect">IT 관련 사이트</a></li>
    <li><a href="http://stackoverflow.com/" target="_blank" class="waves-effect"><i class="material-icons">link</i>스택 오버플로우</a></li>
    <li><a href="http://okky.kr/" target="_blank" class="waves-effect"><i class="material-icons">link</i>OKKY</a></li>
    <li><a class="subheader">개발 기록</a></li>
    <li><a href="http://kdevkr.tistory.com/" target="_blank" class="waves-effect"><i class="material-icons">room</i>개발자 블로그</a></li>
</ul>
		</header>
				<!-- 아티클 영역 -->
	<article>
	<div class="valign-wrapper" style="width: 100%; height: 100%;">
		<div class="valign center" style="margin: auto;">
			<h4>로그인 페이지</h4>
			<form action="${pageContext.request.contextPath}/login" method="post" class="form-inline center-align">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<div class="col s12">
					<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
						<p class="red-text">아이디 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요</p>
					</c:if>
				</div>
				<br>
				<div class="form-group">
					<input id="username" type="text" name="username"
						class="form-control" placeholder="아이디" value="" required>
				</div>
				<div class="form-group">
					<input id="password" type="password" name="password"
						class="form-control" placeholder="패스워드" value="" required>
				</div>
				<button type="submit"
					class="btn blue lighten-2 waves-effect waves-light z-depth-0">
					로그인
				</button>
				<p></p>
					<div class="flex-box">
			<a class="btn light-blue darken-2 waves-effect waves-light white-text btn-full z-depth-0" href="${pageContext.request.contextPath}/connect/facebook">페이스북 계정으로 이용하기</a> 
			<a class="btn amber lignten-1 waves-effect waves-light white-text btn-full z-depth-0" href="${pageContext.request.contextPath}/connect/kakao">카카오톡 계정으로 이용하기</a>
		</div>
			</form>
		</div>
	</div>
	</article>
				<div class="fixed-action-btn click-to-toggle">
					<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"><i class="material-icons">web</i>
					</a>
				</div>
				
				<script type="text/javascript">
$(function() {			
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	});
	$(".button-collapse").sideNav();
});
</script>

<script>
function withdraw(id){
	if(!confirm("정말로 탈퇴하시겠습니까?"))
		return;
	
	$.ajax({
		type	: 'DELETE',
		url		: '/user/'+id,
		success	: function(response){
			Materialize.toast("정상적으로 탈퇴되었습니다.", 3000);
			location.href="/";
		},
		error	: function(response){
			console.log(response);
			Materialize.toast("탈퇴하지 못했습니다", 3000);
		}
	});
}

/**
 *  게시물 작성 알림 시스템
 */
 var stompClient = null;
 
function sendMessage(message){
	if(stompClient != null)
		stompClient.send("/message/notify/", {}, JSON.stringify({'message':message}));
}

$(function() {
	var socket = new SockJS("/websocket");
	stompClient = Stomp.over(socket);
	stompClient.debug = null;
	stompClient.connect({},function(frame) {
		stompClient.subscribe('/board', function(response){
			Materialize.toast("알림 전송. 개발자 도구를 확인하세요",3000,'green',function(){
				console.log(message);
			});
		});
		
	}, function(message){
		Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){
			console.log(message);
		});
	});
});
</script>
			
</body>
</html>
