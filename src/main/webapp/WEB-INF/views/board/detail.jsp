<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
    <%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html ng-app="myApp">
<head>
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>게시판 자세히 보기</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<link rel="stylesheet"	href="/assets/css/style.css">
<style type="text/css">
	header, article, footer{
		    padding-left: 300px;
		}
	.toolbar{
			z-index:999999;
		}
	@media only screen and (max-width: 992px){
		header, article, footer{
		    padding-left: 0;
		}
	}
</style>
</head>
<body id="DetailController" ng-controller="DetailController">
<sec:authentication var="user" property="principal"/>
<header>
		<div class="navbar-fixed">
			<nav class="z-depth-0">
				<div class="nav-wrapper blue lighten-1">
					<form class="" style="margin-bottom: 0;" autocomplete="off">
						<div class="input-field">
							<input id="search" type="search" placeholder="키워드로 검색해보세요 ^ㅡ^" required ng-model="searchKeyword" kr-input>
							<label for="search"><i class="material-icons">search</i></label>
							<i class="material-icons">close</i>
						</div>
					</form>
				</div>
			</nav>
		</div>
		<c:import url="/sidenav" />
	</header>
	<article>
	<!-- 게시물 컨트롤러 만들기 -->
	<div class="container">
	<div class="card sticky-action" ng-if="boardContent != null">
						<div class="card-image" style="padding:20px; padding-bottom:0;">
						    <span class="chip red lighten-2 hover white-text" style="border-radius:0; position:absolute; top:0; right:0; margin-right:0; padding-left:0;">
						    <span class="chip blue lighten-2 hover white-text" data-ng-click="" style="border-radius:0; margin-right:10px;">답변 {{boardContent.comments.length}}개</span>{{boardContent.category}}</span>
							<span style="font-weight:700; font-size:18px;">{{boardContent.title}}</span>
							
						</div>
						<div class="card-content">
							<div class="justify-align">
							<sec:authorize access="isAuthenticated()">
			      <c:if test="${content.user.id == user.id}">
			      	<div class="secondary-content">
			      		<a class="hover" data-ng-click="requestBoardUpdate();"><i class="material-icons grey-text text-darken-2">settings</i></a>
			      		<a class="hover" data-ng-click="requestBoardDelete();"><i class="material-icons grey-text text-darken-2">delete_forever</i></a>
			      	</div>
			      </c:if>
		      </sec:authorize>
								{{boardContent.description}}
							</div>
						</div>
						<div class="card-action right-align">
												<span class="chip white left">
							    <img style="height:100%;" ng-src="{{boardContent.user.thumbnail}}">
							   {{boardContent.user.nickname}}
							  </span>
							 <span class="tags" ng-if="boardContent.tags != null" ng-init="chip=parseJson(boardContent.tags)">
								<span ng-repeat="t in chip"><span class="chip red lighten-2 hover white-text" style="">{{t.tag}} </span></span>
							</span>
							
							 
						<span class="chip grey darken-2 white-text">{{boardContent.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
						</div>
					</div>
		  <sec:authorize access="isAnonymous()">
		  	<div class="collection">
			<div class="collection-item center">
				<a href="/login">로그인</a> 하셔야 답변을 다실 수 있습니다.
			</div>
			</div>
		
		  </sec:authorize>
		  <sec:authorize access="isAuthenticated()">
		  			        			<!-- Modal Structure -->
			<div id="updateBoardModal" class="modal modal-fixed-footer white">
				<div class="modal-content">
					<div class="collection">
			<div class="collection-item">
				<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    ${user.nickname}
				</span>
					<div class="row">
						<div class="input-field col s12">
							<input id="u_b_title" name="u_b_title" type="text" />
							<label class="active" for="u_b_title">제목</label>
						</div>
						<div class="input-field col s12">
							<textarea id="u_b_description" class="materialize-textarea"></textarea>
							<label for="u_b_description">DESCRIPTION</label>
						</div>
						<div class="input-field col s12">
								<div id="u_b_tags" class="chips chips-placeholder"></div>
						</div>					
					</div>
				</div>
				</div>
				</div>
				
				<div class="modal-footer white">
					<a class="modal-action modal-close waves-effect waves-light btn-flat">닫기</a>
					<a class="waves-effect waves-light btn-flat" id="updateBoardBtn">수정하기</a>
				</div>
			</div>
			</sec:authorize>
		  <sec:authorize access="isAuthenticated()">
		<div class="collection col m4">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    ${user.nickname}
				</span>
			<div class="input-field">
				<input id="c_description" name="c_description" type="text" />
				<label class="active" for="c_description">내용을 작성해주시기 바랍니다.</label>
			</div>
			<div class="input-field">
				<div id="c_tags" class="chips chips-placeholder"></div>
			</div>
			<div class="right-align"><button id="comment_form_btn" class="btn teal lighten-2 white-text" onclick="comment(${content.id});">답변하기</button></div>
		    </div>
		</div>
			<!-- Modal Structure -->
			<div id="updateCommentModal" class="modal modal-fixed-footer white">
				<div class="modal-content">
					<div class="row">
						<div class="col s12">
				<div class="input-field col s12">
									<textarea id="u_c_description" class="materialize-textarea"></textarea>
									<label for="u_c_description">DESCRIPTION</label>
								</div>
																<div class="input-field col s12">
								<div id="u_c_tags" class="chips chips-placeholder"></div>
				</div>
						</div>					
					</div>
				</div>
				
				<div class="modal-footer white">
					<a class="modal-action modal-close waves-effect waves-light btn-flat">닫기</a>
					<a class="waves-effect waves-light btn-flat" id="updateCommentBtn">수정하기</a>
				</div>
			</div>
		</sec:authorize>
		<div class="collection" dir-paginate="comment in search_contents = (boardContent.comments | filter:searchKeyword | orderBy:'-id') | itemsPerPage:5" pagination-id="commentpage">
			<div class="collection-item">
		    	<span class="chip transparent right"><a class="grey-text">{{comment.created | date:'yyyy년 MM월 dd일 h:mma'}}</a>&nbsp;
		    	<sec:authorize access="isAuthenticated()">
		    	<span ng-if="comment.user.id == ${user.id}">
		    		<a class="blue-text hover" data-ng-click="requestUpdate(comment, $index);">수정</a>&nbsp;
		    		<a class="blue-text hover" data-ng-click="requestDelete(comment);">삭제</a>
		    	</span>
		    	</sec:authorize>
		    	</span>
		    	<span class="chip transparent">
					<img ng-src="{{comment.user.thumbnail}}" alt="Contact Person">
					    {{comment.user.nickname}}
				</span>
				<br>
				<p class="collection-title">{{comment.description}}</p>
				
		    </div>
		    <div class="collection-item" ng-if="comment.tags != '[]'">
		    <span class="tags" ng-init="chip=parseJson(comment.tags)">
								<span ng-repeat="t in chip"><span class="chip red lighten-2 hover white-text" style="border-radius:0;">{{t.tag}} </span></span>
				</span>
		    </div>
		    </div>
	  	<div class="center-align">
				<dir-pagination-controls
					    max-size="5"
					    template-url="/assets/html/dirPagination.tpl.html"
					    direction-links="true"
   						boundary-links="true"
					    pagination-id="commentpage">
					    </dir-pagination-controls>
					
				</div>

	  <div class="center">
	  	<button class="btn red lighten-2" onclick="location.href='/';">이전으로</button>
	  	<p></p>
	  </div>
	</div>
	</article>
	<div class="fixed-action-btn click-to-toggle">
	<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile"> <i class="material-icons">web</i>
	</a>
	</div>
	<div id="preloader" class="fixed-action-btn" style="z-index:99999; left:0; padding-left:20px;">
	<div class="preloader-wrapper active">
      <div class="spinner-layer spinner-blue">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-red">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-yellow">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>

      <div class="spinner-layer spinner-green">
        <div class="circle-clipper left">
          <div class="circle"></div>
        </div><div class="gap-patch">
          <div class="circle"></div>
        </div><div class="circle-clipper right">
          <div class="circle"></div>
        </div>
      </div>
    </div>
	</div>
<!-- Compiled and minified JavaScript -->
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
<script	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
<script	src="/assets/js/dirPagination.js"></script>
<script src="/assets/js/app.js"></script>
<script type="text/javascript">
var token = $("meta[name='_csrf']").attr("content");
var header = $("meta[name='_csrf_header']").attr("content");

$(function() {
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(header, token);
	});
});

$(document).ready(function() {
	$('.chips-placeholder').material_chip({
	    placeholder: 'Enter a tag',
	    secondaryPlaceholder: 'Enter a tag',
	  });
	$('.modal').modal();
	$(".button-collapse").sideNav();
	$('#preloader').hide();
	getBoardDetail(${content.id});
  });
  

</script>
</body>
</html>