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
    <li><a href="/board/category/신입공채" class="waves-effect"><i class="material-icons">folder</i>신입공채</a></li>
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
							<div class="card-action" style="padding:5px 10px;" ng-if="x.tags != '[]'">
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
							<div class="card-action" style="padding:5px 10px;" ng-if="x.tags != '[]'">
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
		
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="/assets/js/sockjs-0.3.4.min.js"></script>
<script src="/assets/js/stomp.min.js"></script>

<!-- Compiled and minified JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script src="/assets/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js" integrity="sha384-BLiI7JTZm+JWlgKa0M0kGRpJbF2J8q+qreVrKBC47e3K6BW78kGLrCkeRX6I9RoK" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="/assets/js/tagging.js"></script>
<script src="/assets/js/summernote-ko-KR.min.js"></script>
<script	src="/assets/js/angular.min.js"></script>
<script	src="/assets/js/dirPagination.js"></script>
<script	src="/assets/js/angular-sanitize.min.js"></script>

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
<script src="/assets/js/app.js"></script>
	</body>
</html>
