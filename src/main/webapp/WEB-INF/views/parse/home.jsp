<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<html ng-app="myApp">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title>Community Webservice Platform</title>

		<!--Import Google Icon Font-->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons"	rel="stylesheet">
		<!-- Compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
		<style>
			a.link:hover{
				color:#000;
			}
			span.badge {
				color:#fff !important;
			}
		</style>
	</head>
	<body id="ParseErrorController" ng-controller="ParseErrorController" ng-cloak>
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
    <li><a href="${pageContext.request.contextPath}/parse" class="waves-effect"><i class="material-icons">room</i>자바 에러 분석 기능</a></li>
    <li><a href="https://kdevkr.github.io/" target="_blank" class="waves-effect"><i class="material-icons">room</i>KDev Github Blog</a></li>
</ul>
		</header>
		<!-- 아티클 영역 -->
		<article>
			<div class="container-fluid">
<p></p>
<div class="form-group wrap">
<textarea class="form-control rounded-0 border-bottom-0 ngc" style="height:300px;" spellcheck="false" id="errorTextarea" ng-model="errorText">
</textarea>
<button type="button" class="btn btn-outline-primary rounded-0" style="width:100%;" data-ng-click="parseError()">에러 키워드 분석하기(자바 전용)</button>
</div>
<p></p>
		<div class="card rounded-0" ng-show="parsedError">
			<div class="card-header">
			 <span ng-if="parsedError != null && parsedError.length == 0">키워드를 파악할 수 없습니다.</span>
				<p ng-repeat="error in parsedError track by $index">
					<span class="badge badge-default unselectable" style="margin-right:5px;">{{$index+1}}</span>
					<span ng-bind-html="trustHtml(error)" style="word-wrap:break-word;"></span>
				</p>
			</div>
			<div class="card-block">
			<b ng-if="parsedErrorRecommanded != null && parsedErrorRecommanded.length != 0">분석 결과 다음의 부분을 자세히 확인하시는 것을 추천드립니다.</b>
			<b ng-if="parsedErrorRecommanded != null && parsedErrorRecommanded.length == 0">시스템이 완벽하지 않아 분석할 수 없었어요 ㅠㅠ</b>
				<p ng-repeat="error in parsedErrorRecommanded track by $index">
					<span ng-bind-html="trustHtml(error)" style="word-wrap:break-word;"></span>
				</p>
			</div>
		</div>
<p></p>
<div style="background-color:#fff;">
<input ng-enter="loadDataSet()" id="searchText" class="form-control rounded-0" type="text" placeholder="검색할 에러키워드를 입력하세요">
</div>
<p></p>
<div class="row">
	<!-- Block -->
	<div class="col-lg-4">
		<div class="card rounded-0" style="margin-bottom:0;">
								<div class="progress rounded-0" ng-show="stackOverflowLoading">
	  <div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width: 100%; height: 20px;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
	</div>
			<div class="card-header border-bottom-0">
				<kbd>Stack Overflow</kbd> <span class="right" ng-if="stackOverflowDataSet"> {{stackOverflowDataSet.length}}개</span>
			</div>
		</div>
		<div class="card border-top-0 rounded-0" style="margin-top:0;" ng-if="stackOverflowDataSet">
		  <div class="card-block">
		    <div dir-paginate="data in searchDataSet = stackOverflowDataSet | itemsPerPage:15" pagination-id="stackoverflowpage">
		    	<p class="card-text mt-0">
		    	<span class="badge badge-default">{{$index+1}}</span>&nbsp;
		    		<a class="link" ng-href="{{data.href}}" target="_blank" style="word-wrap:break-word;">
		    			<b>{{data.title}}</b>
		    		</a>
		    	</p>
		    	<hr>
		    </div>
		    <p></p>
 			<dir-pagination-controls
			    max-size="5"
			    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
			    direction-links="true"
 				boundary-links="true"
			    pagination-id="stackoverflowpage"
			>
			</dir-pagination-controls>
		  </div>
		</div>
	</div>
	<!-- /Block -->
	<!-- Block -->
	<div class="col-lg-4">
		<div class="card rounded-0" style="margin-bottom:0;">
						<div class="progress rounded-0" ng-show="okkyLoading">
	  <div class="progress-bar progress-bar-striped progress-bar-animated bg-primary" role="progressbar" style="width: 100%; height: 20px;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
	</div>
			<div class="card-header border-bottom-0">
				<kbd>OKKY</kbd> <span class="right" ng-if="okkyDataSet"> {{okkyDataSet.length}}개</span>
			</div>
		</div>
		<div class="card border-top-0 rounded-0" style="margin-top:0;" ng-if="okkyDataSet">
		  <div class="card-block">
		    <div dir-paginate="data in searchDataSet = okkyDataSet | itemsPerPage:15" pagination-id="okkypage">
		    	<p class="card-text mt-0">
		    	<span class="badge badge-default">{{$index+1}}</span>&nbsp;
		    		<a class="link" ng-href="{{data.href}}" target="_blank" style="word-wrap:break-word;">
		    			<b>{{data.title}}</b>
		    		</a>
		    	</p>
		    	<hr>
		    </div>
		    <p></p>
 			<dir-pagination-controls
			    max-size="5"
			    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
			    direction-links="true"
 				boundary-links="true"
			    pagination-id="okkypage"
			>
			</dir-pagination-controls>
		  </div>
		</div>
	</div>
	<!-- /Block -->
	<!-- Block -->
	<div class="col-lg-4">
		<div class="card rounded-0" style="margin-bottom:0;">
				<div class="progress rounded-0" ng-show="daumLoading">
	  <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" style="width: 100%; height: 20px;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
	</div>
			<div class="card-header border-bottom-0">
				<kbd>Daum API</kbd> <span class="right" ng-if="daumDataSet"> {{daumDataSet.length}}개</span>
			</div>
		</div>
		<div class="card border-top-0 rounded-0" style="margin-top:0;" ng-if="daumDataSet">
		  <div class="card-block">
		    <div dir-paginate="data in searchDataSet = daumDataSet | itemsPerPage:15" pagination-id="daumpage">
		    	<p class="card-text mt-0">
		    	<span class="badge badge-default">{{$index+1}}</span>&nbsp;
		    		<a class="link" ng-href="{{data.href}}" target="_blank" style="word-wrap:break-word;">
		    			<b ng-bind-html="data.title"></b>
		    		</a>
		    	</p>
		    	<hr>
		    </div>
		    <p></p>
 			<dir-pagination-controls
			    max-size="5"
			    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
			    direction-links="true"
 				boundary-links="true"
			    pagination-id="daumpage"
			>
			</dir-pagination-controls>
		  </div>
		</div>
	</div>
	<!-- /Block -->
	</div>
</div>
<p></p>
<div class="jumbotron my-0 rounded-0">
  <h2 class="center-align">Warnning! No Founded Result?</h2>
  <p class="lead center-align">Please register your question through the site below.</p>
  <hr class="my-4">
  <p class="row center-align"><a href="#" class="col">StackOverflow</a><a href="#" class="col">Okky</a></p>
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
<script	src="/assets/js/dirPagination.js"></script>
<script src="/assets/js/tagging.js"></script>


<script type="text/javascript">
var contextPath = '${pageContext.request.contextPath}';
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
</script>
<script>
var app = angular.module("myApp",['angularUtils.directives.dirPagination','ngSanitize']);

app.directive('ngEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.ngEnter);
                });
 
                event.preventDefault();
            }
        });
    };
});

app.controller('ParseErrorController', function($rootScope, $scope, $http, $sce){
	
	$scope.okkyLoading = false;
	
	$scope.trustHtml = function(html){
		return $sce.trustAsHtml(html);
	}
	$scope.parseError = function(){
		
		if($scope.errorText == null || $scope.errorText.length == 0){
			alert("에러 내용을 붙여넣으세요");
			return;
		}
		
		if($scope.errorText.length > 20000){
			alert("에러 내용이 너무 길어요");
			return;
		}
		
		var dataObject = new Object();
    	dataObject.error = $scope.errorText;
    	$scope.parsedError = null;
    	
    	$.ajax({
			type	: 'POST',
			url		: contextPath+'/parse/error',
			data : dataObject,
			dataType	: 'JSON',
			success	: function(response){
				if(response != "" && response != null){
					$scope.$apply(function () {
						$scope.parsedError = response.filtered;
						$scope.parsedErrorRecommanded = response.recommanded;
					});
				}
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
					console.log(response);
				});
			}
		});
    	//$scope.parsedError = response.filtered;
		//$scope.parsedErrorRecommanded = response.recommanded;
	}
	$scope.loadDataSet = function(){
		var searchText = $('#searchText').val();
		
		if(searchText == "" || searchText == null){
			alert("키워드를 입력하세요");
			$('#searchText').focus();
			return;
		}
		
		if(searchText.length > 1000){
			alert("키워드가 너무 길어요");
			return;
		}
		
		$scope.okkyLoading = true;
		$scope.stackOverflowLoading = true;
		$scope.daumLoading = true;
		
		$scope.okkyDataSet = null;
		$scope.stackOverflowDataSet = null;
		$scope.daumDataSet = null;
		
    	var dataObject = new Object();
    	dataObject.keyword = searchText;
    	
    	//OKKY에서 검색하기
    	  $http({
    		method : 'GET',
    		url : contextPath+'parse/search/okky',
    		params : dataObject
    	}).then(function(response){
    		$scope.okkyDataSet = response.data;
    	},function(response){
			console.log(response);
    	}).then(function(){
    		$scope.okkyLoading = false;
    	});
    	
    	//StackOverflow에서 검색하기
    	  $http({
    		method : 'GET',
    		url : contextPath+'parse/search/stackoverflow',
    		params : dataObject
    	}).then(function(response){
    		$scope.stackOverflowDataSet = response.data;
    	},function(response){
			console.log(response);
    	}).then(function(){
    		$scope.stackOverflowLoading = false;
    	});
    	
    	//Daum에서 검색하기
    	$http({
    		method : 'GET',
    		url : contextPath+'parse/search/daum',
    		params : dataObject
    	}).then(function(response){
    		$scope.daumDataSet = response.data;
    	},function(response){
			console.log(response);
    	}).then(function(){
    		$scope.daumLoading = false;
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
});
</script>
	</body>
</html>
