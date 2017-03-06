<!-- JSP 및 태그라이브러리 설정 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html ng-app="myApp">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		
		<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
		<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
		<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />

		<title>Community Webservice Platform</title>

		<!--Import Google Icon Font-->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons"	rel="stylesheet">
		<!-- Compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
	</head>
	<body id="AdminController" ng-controller="AdminController" ng-cloak>
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
      	  <a href="#"><img class="circle" src="/assets/img/user-star.png" style="margin:0 auto;"></a>
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
				<!-- 게시물 페이지네이션 영역 -->
				<p></p>
				<div class="row center-align">
				<h3 style="margin-top:50px;"></h3>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<span class="chip green lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">전체 사용자수
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${userCount}명</span>
						</span>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<span class="chip blue lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">페이스북 사용자
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${facebookUser}명</span>
						</span>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<span class="chip orange lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">카카오톡 사용자
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${kakaoUser}명</span>
						</span>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<span class="chip purple lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">제재 사용자
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${restrictCount}명</span>
						</span>
					</div>
					<div class="col-sm-12 col-md-6">
						<span class="chip pink lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">전체 게시물수
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${boardCount}개</span>
						</span>
					</div>
					<div class="col-sm-12 col-md-6">
						<span class="chip red lighten-2 hover white-text" style="border-radius:0; padding-right:0; width:100%;">시스템 메모리
							<span class="chip grey darken-2 hover white-text right" style="border-radius:0; margin-right:0;">${systemMemory}MB</span>
						</span>
					</div>
				</div>
				
				<!-- 게시물 영역 -->
				<div class="row">
				<div class="col-sm-12">
					<div class="collection">
						<div class="collection-item">
							<div class="row">
								<div class="col-sm-12">
							<b>회원 소셜 타입</b>
									<select id="provider" class="browser-default form-control">
								      <option value="" disabled selected>소셜 구분을 선택해주세요</option>
								      <option value="Kakao">Kakao</option>
								      <option value="Facebook">Facebook</option>
								    </select>
								    <p></p>
								</div>
								
								<div class="col-sm-12">
									<b>회원 번호</b><input id="id" name="id" type="text" class="form-control validate"/>
								<p></p>
								</div>
								
								<div class="col-sm-12">
									<b>제재 사유</b><input id="reason" name="reason" type="text" class="form-control validate"/>
								<p></p>
								</div>
								<div class="col-sm-12">
									<b>해제 일자</b><input id="released" name="released" type="date" class="form-control validate"/>
								<p></p>
								</div>
								
								<div class="col-sm-12 right-align flex-box">
									<a class="btn blue lighten-2 white-text btn-full" data-ng-click="insertRestrict()">등록하기</a>
								</div>
							</div>
						</div>
					</div>
					</div>
					<div class="col-sm-12">
					<div class="collection">
						<div class="collection-item">
							<b>제재된 리스트 {{totalRestrictList}}개</b>
						</div>
							<div class="collection-item" ng-if="totalRestrictList > 0">
							<p dir-paginate="x in search_contents = (restrictList) | itemsPerPage:pagesize" pagination-id="restrictpage" total-items="totalRestrictList">
								{{x.provider}} - {{x.userid}} : {{x.reason}} - {{x.released | date:'yyyy년 MM월 dd일'}}까지 <a href="#" data-ng-click="cancelRestriction(x.provider, x.userid, $index)">해제</a>
							</p>
						</div>
					<div class="center-align">
						<dir-pagination-controls
						    max-size="5"
						    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
						    direction-links="true"
	   						boundary-links="true"
						    pagination-id="restrictpage"
						    on-page-change="pageChange(newPageNumber-1)"
						    >
						</dir-pagination-controls>
						</div>
					</div>
					</div>
				</div>
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
<script type="text/javascript">
var contextPath = '${pageContext.request.contextPath}';
	$(".button-collapse").sideNav();
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	$(function() {			
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(header, token);
		});
	});
	
	var app = angular.module('myApp', ['ngSanitize','angularUtils.directives.dirPagination']);
	
	app.controller('AdminController', function($scope){
		$scope.searchKeyword = '';
		$scope.pagesize = 5;
		$scope.totalRestrictList = 0;
		
		$scope.pageChange = function(page){
			$scope.loadDataSet(page, $scope.pagesize, $scope.searchKeyword);
		}
		
		$scope.insertRestrict = function(){
			if($('#provider').val() == "" || $('#provider').val() == null){
				Materialize.toast("회원 소셜 타입를 선택해주세요",3000,'orange',function(){

				});
				$('#provider').focus();
				return;
			}
			if($('#id').val() == "" || $('#id').val() == null){
				Materialize.toast("회원 번호를 입력해주세요",3000,'orange',function(){
					
				});
				$('#id').focus();
				return;
			}
			if($('#reason').val() == "" || $('#reason').val() == null){
				Materialize.toast("제재 사유를 입력해주세요",3000,'orange',function(){

				});
				$('#reason').focus();
				return;
			}
			if($('#released').val() == "" || $('#released').val() == null){
				Materialize.toast("해제 일자를 입력해주세요",3000,'orange',function(){

				});
				$('#released').focus();
				return;
			}
			var dataObject = new Object();
			
			dataObject.provider = $('#provider').val();
			dataObject.userid = $('#id').val();
			dataObject.reason = $('#reason').val();
			dataObject.released = $('#released').val();
			
			$.ajax({
				type	: 'POST',
				url		: contextPath+'/restriction',		
				data	: JSON.stringify(dataObject),
				contentType: 'application/json',
				dataType	: 'JSON',
				success	: function(response){
					Materialize.toast("제재 되었습니다.",3000,'green',function(){
						
					});
					$scope.loadDataSet(0, $scope.pagesize, $scope.searchKeyword);
					
				},
				error	: function(response){
					Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){
						console.log(response);
					});
				}
			});
		}
		
		$scope.cancelRestriction = function(provider, userid, index){
			var dataObject = new Object();
			
			dataObject.provider = provider;
			dataObject.userid = userid;
			
			$.ajax({
				type	: 'DELETE',
				url		: contextPath+'/restriction',		
				data	: JSON.stringify(dataObject),
				contentType: 'application/json',
				dataType	: 'JSON',
				success	: function(response){
					Materialize.toast("해제되었습니다.",3000,'green',function(){
						
					});
					$scope.$apply(function(){
						$scope.loadDataSet(0, $scope.pagesize, $scope.searchKeyword);
					});
				},
				error	: function(response){
					Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){
						console.log(response);
					});
				}
			});
		}
		$scope.loadDataSet = function(page, size, search){
			var dataObject = {
					page : page,
					size : size,
					search : search
				};
				
				$.ajax({
					type	: 'GET',
					url		: contextPath+'/restriction',
					data	: dataObject,
					dataType	: 'JSON',
					success	: function(response){
						if(response != "" && response != null){
							$scope.$apply(function () {
								$scope.totalRestrictList = response.totalElements;
								$scope.restrictList = response.content;
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
		$scope.loadDataSet(0, $scope.pagesize, $scope.searchKeyword);
	});
</script>
</body>
</html>
