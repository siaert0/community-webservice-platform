<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html ng-app="myApp">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title>Community Webservice Platform</title>

		<!--Import Google Icon Font-->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons"	rel="stylesheet">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
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
			<div class="container-fluid">
			<p></p>
				<!-- 게시물 페이지네이션 영역 -->
				<div class="row">
				<p></p>
					<div class="col-sm-12">
						<span class="chip grey darken-2 hover white-text" style="border-radius:0;">스크랩 수 {{totalElements}}개</span>
						</div>
				</div>
				<div dir-paginate="x in search_contents = (scraps | filter:searchKeyword | orderBy:-index) | itemsPerPage:pagesize" pagination-id="scrappage" total-items="totalElements">
						<div class="card sticky-action border-flat" ng-class="{selectedBoard:x.selected != 0, commentedBoard:x.selected == 0 && x.comments.length > 0}" style="margin:0; margin-top:5px;">
							<div class="card-content" style="padding:10px; padding-top:15px;">
								<span class="chip white left">
							      <img style="height:100%;" ng-src="{{x.board.user.thumbnail}}">
								   {{x.board.user.nickname}}
								  </span>
								  <span class="chip transparent teal-text border-flat left">{{x.board.category}}</span>
								<span class="chip transparent blue-text border-flat left">댓글 {{x.board.comments.length}}</span>
								<span class="chip transparent red-text border-flat left">추천 {{x.board.thumbs.length}}</span>
								<span class="chip transparent black-text border-flat">{{x.board.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
								<span class="chip transparent pink-text waves-effect waves-light" data-ng-click="scrap(x.board.id, $index)">스크랩 취소</span>
								</div>
							<div class="card-content" style="padding-top:0;">
								<a class="hover-black hover" ng-href="${pageContext.request.contextPath}/board/{{x.board.id}}" style="color:#444; font-weight:700; font-size:15px;">{{x.board.title}}</a>
							</div>
							<div class="card-action" style="padding:5px 10px;" ng-if="x.board.tags != '[]'">
								<span class="tags" ng-init="tags=parseJson(x.board.tags)">
									<span ng-repeat="tag in tags"><span class="chip transparent red-text hover border-flat" style="margin:0;">{{tag}} </span>
								  </span>
								</span>
								
							</div>
						</div>
					</div>
				<!-- 게시물 영역 -->
				<p></p>
				
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
		</article>

<!-- Compiled and minified JavaScript -->		
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/lang/summernote-ko-KR.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular-sanitize.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/tagging.js"></script>
<script	src="${pageContext.request.contextPath}/assets/js/dirPagination.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sockjs.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/stomp.min.js"></script>
<script type="text/javascript">
var notify_count = 0;
var title = document.title;
var stompClient = null;
var contextPath = '${pageContext.request.contextPath}';
$(function() {		
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	});
	$(".button-collapse").sideNav();
	
	if (!("Notification" in window)) {
		Materialize.toast("알림 기능이 지원되지 않는 브라우저입니다.",3000,'red',function(){});
	}
	else if (Notification.permission !== 'denied') {
	    Notification.requestPermission(function (permission) {
	      if (permission === "granted") {
	    	  Materialize.toast("알림 기능이 활성화 되었습니다.",3000,'green',function(){});
	      }
	    });
	}
	
	if (Notification.permission === "granted") {
		var socket = new SockJS("/websocket");
		stompClient = Stomp.over(socket);
		stompClient.debug = true;
		stompClient.connect({},function(frame) {
			stompClient.subscribe('/notification', function(response){
				var obj = JSON.parse(response.body);
				var options = {
					      body: obj.message,
					      icon: obj.user.thumbnail
					  }
				var notification = new Notification("Community Webservice Platform",options);
				notify_count++;
				var newTitle = '(' + notify_count + ') ' + title;
			    document.title = newTitle;
				notification.onclick = function(){
					location.href=obj.href;
                	this.close();
                };
				setTimeout(function () {
		            notification.close();
		        }, 5000);
				
			});
			
		}, function(message){
			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){
				console.log(message);
			});
		});
	}
	
	$(window).on("focus", function(){
		notify_count = 0;
		document.title = title;
	});
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
    	        url: contextPath+'/board/scrap',
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
    		location.href=contextPath+"/board/"+value;
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
		    		url		: contextPath+'/board/scrap/'+$scope.scrapUser,
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
    	$scope.loadDataSet(0, $scope.pagesize);
    });
</script>
</body>
</html>
