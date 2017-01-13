<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
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
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
	</head>
	<body id="ScrapController" ng-controller="ScrapController" ng-cloak>
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
				<div class="row left-align">
				<p></p>
				<blockquote>
					<div class="col s12">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0;">스크랩 수</span>
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">{{totalElements}}개</span>
						</div>
				</blockquote>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">		
				<div dir-paginate="x in search_contents = (scraps | filter:searchKeyword | orderBy:-index) | itemsPerPage:pagesize" pagination-id="scrappage" total-items="totalElements">
					<div class="col s12">
						<div class="card sticky-action hoverable border-flat" ng-class="{selectedBoard:x.board.selected != 0, commentedBoard:x.board.selected == 0 && x.board.comments.length > 0}">
							<div class="card-content">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.board.user.thumbnail}}">
								   {{x.board.user.nickname}}
								  </span>
								<span style="font-weight:700; font-size:18px;">{{x.board.title}}</span>
							</div>
							<div class="card-action right-align">
								<span class="chip teal lighten-2 hover white-text border-flat left">{{x.board.category}}</span>
							<span class="chip lighten-2 hover white-text border-flat left" ng-class="{blue:x.board.selected == 0 && x.board.comments.length > 0, grey:x.board.selected == 0 && x.board.comments.length == 0, green:x.board.selected != 0}">댓글 {{x.board.comments.length}}</span>
								<span class="chip lighten-2 hover white-text border-flat left" ng-class="{red:checkThumb({{x.board}})==0, green:checkThumb({{x.board}})==1, blue:checkThumb({{x.board}})==2}">추천 {{x.board.thumbs.length}}</span>
								<span class="chip green lighten-2 hover white-text border-flat" data-ng-click="move(x.board.id)">이동</span>
								<span class="chip red lighten-2 hover white-text border-flat" data-ng-click="scrap(x.board.id, $index)">스크랩 취소</span>
								
							</div>
						</div>
					</div>
					</div>
				</div>
				
				<!-- 게시물 페이지네이션 영역 -->
					<div class="center-align">
						<dir-pagination-controls
						    max-size="5"
						    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
						    direction-links="true"
	   						boundary-links="true"
						    pagination-id="scrappage"
						    on-page-change="pageChange(newPageNumber-1)"
						    >
						</dir-pagination-controls>
					</div>
			</div>
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
<script src="/assets/js/sockjs-0.3.4.min.js"></script>
<script src="/assets/js/stomp.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script src="/assets/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="/assets/js/tagging.js"></script>
<script src="/assets/js/summernote-ko-KR.min.js"></script>
<script	src="/assets/js/angular.min.js"></script>
<script	src="/assets/js/dirPagination.js"></script>


<script type="text/javascript">
$(function() {		
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	});
	$(".button-collapse").sideNav();
});

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
	    
    var app = angular.module('myApp', ['angularUtils.directives.dirPagination']);
    
    /**
     * ####################
     * 스크랩 관련 컨트롤러
     * ####################
     */

    app.controller('ScrapController', function($scope, $http){
    	$scope.scrapUser='${scrapUser}';
    	$scope.pagesize = 5;
    	$scope.totalElements = 0;
    	
    	$scope.scrap = function(id, index){
    		var dataObject = new Object();
    		dataObject.boardid = id;
    		
    		$.ajax({
    	        type: 'DELETE',
    	        url: '/board/scrap',
    	        contentType: 'application/json',
    	        data: JSON.stringify(dataObject),
    	        dataType: 'TEXT', //리턴되는 데이타 타입
    	        success: function(response){
    	        		$scope.totalElements = $scope.totalElements - 1;
    	        		$scope.scraps.splice(index, 1);
    	        		$scope.$apply();
    	  			Materialize.toast("스크랩을 취소하였습니다.",3000,'green',function(){
    	  				
    				});
    	        	
    	        },error: function(response){
    	  			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
    					console.log(response);
    				});
    	        }
    	    });
    	}
    	$scope.parseJson = function (json) {
            return JSON.parse(json);
        }
    	$scope.move = function (value){
    		location.href="/board/"+value;
    	}
    	$scope.checkThumb = function(boardContent){
    		if(boardContent.thumbs.length > 0){
    			var is = false;
    			if($scope.USERID == null){
    				return 1;
    			}
    			for(var i=0; i < boardContent.thumbs.length; i++){
    				if(boardContent.thumbs[i].board_USER_CP_ID.userid == $scope.USERID){
    					is = true
    					break;
    				}
    			}
    			if(is)
    				return 2;
    			else
    				return 1;
    		}
    		return 0;	
    	}
    	$scope.pageChange = function(page){
    		$scope.loadDataSet(page, $scope.pagesize);
    	}
    	
    	$scope.loadDataSet = function(page, pagesize){
    		var dataObject = {
		    		page : page,
		    		size : pagesize,
		    	};
		    	
		    	$.ajax({
		    		type	: 'GET',
		    		url		: '/board/scrap/'+$scope.scrapUser,
		    		data	: dataObject,
		    		dataType	: 'JSON',
		    		success	: function(response){
		    			if(response != "" && response != null){
		    				$scope.$apply(function () {
		    					$scope.totalElements = response.totalElements;
		    					$scope.scraps = response.content;
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
    	$scope.loadDataSet(0, $scope.pagesize);
    });
</script>
</body>
</html>
