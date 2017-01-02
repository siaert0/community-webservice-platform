<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property="principal"/>
<!DOCTYPE html>
<html ng-app="myApp">
<head>
<!-- 스프링 시큐리티의 CSRF 토큰을 AJAX에서 사용 -->
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>게시판 자세히 보기</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" integrity="sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi" crossorigin="anonymous">

<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<!-- include summernote css/js-->

<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css" rel="stylesheet">
<link rel="stylesheet"  href="/assets/css/tether.min.css">
<link rel="stylesheet"  href="/assets/css/tag-basic-style.css">
<link rel="stylesheet"	href="/assets/css/style.css">
</head>
<body id="DetailController" ng-controller="DetailController" ng-cloak>
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
	<article style="margin-top:0px;">
	<!-- 게시물 컨트롤러 만들기 -->
	<div class="container-fluid">
	<div class="row">
	<div class="col s12 m8">
	<div class="card sticky-action" ng-if="boardContent != null">
		<div class="card-content right-align" style="border-bottom:1px solid #EEE">
		    								<span class="chip white left">
			    <img style="height:100%;" ng-src="{{boardContent.user.thumbnail}}">
			   {{boardContent.user.nickname}}
			  </span>
			
			<span class="chip grey darken-2 white-text border-flat">{{boardContent.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
						<sec:authorize access="isAuthenticated()">
			     <c:if test="${content.user.id == user.id}">
			     <span class="chip red lighten-2 hover white-text border-flat" data-ng-click="requestBoardUpdate();">수정</span>
			     <span class="chip blue lighten-2 hover white-text border-flat" data-ng-click="requestBoardDelete();">삭제</span>
			     </c:if>
			     <span class="chip green lighten-2 hover white-text border-flat" data-ng-click="scrap(boardContent.id)">스크랩</span>
	    		</sec:authorize>
		</div>
		<div class="card-content">
			<div class="justify-align">
				<div class="">
				<p class="" style="font-weight:700; font-size:18px;">{{boardContent.title}}</p>
					<p class="collection-title" ng-bind-html="trustHtml(boardContent.description)"></p>
				</div>
			</div>
		</div>
		<div class="card-action left-align">
		 <span class="chip teal lighten-2 hover white-text border-flat" >{{boardContent.category}}</span>
		<span class="chip lighten-2 hover white-text border-flat" ng-class="{blue:boardContent.selected == 0 && boardContent.comments.length > 0, red:boardContent.selected == 0 && boardContent.comments.length == 0, green:boardContent.selected != 0}">댓글 {{boardContent.comments.length}}</span>
			 
			 
			 <span class="chip lighten-2 hover white-text border-flat" ng-class="{red:checkThumb()==0, green:checkThumb()==1, blue:checkThumb()==2}" data-ng-click="toggleThumb();">추천 {{boardContent.thumbs.length}}</span>
			
			 <span class="tags right" ng-if="boardContent.tags != null" ng-init="tags=parseJson(boardContent.tags)">
				<span ng-repeat="tag in tags"><span class="chip red lighten-2 hover white-text border-flat" style="">{{tag}} </span></span>
			</span>
		</div>
	</div>
	</div>
	<!-- 실시간 구독 영역 -->
	<div class="col s12 m4">
		<div class="collection">
			<div class="collection-item center-align">
				실시간으로 물어보세요
			</div>
			<div id="messagebox" class="collection-item" style="min-height:255px; max-height:255px; overflow:auto; padding-left:10px; padding-right:10px; overflow-wrap:break-word;">
				<p class="" ng-repeat="message in messages">
					
			   <span style="border-right:2px solid red; padding-right:10px;">{{message.user.nickname}}</span>
			  &nbsp;
			  {{message.message}}
				</p>
			</div>
			<div class="collection-item" style="padding:0.5rem;">
			<sec:authorize access="isAnonymous()">
				<div class="center-align"><a href="/login">로그인</a> 하고 대화에 참여하기</div>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<input id="message" type="text" class="" style="margin:0;" placeholder="메시지 입력" onkeypress="if(event.keyCode==13) {sendMessage(this); return false;}"/>
			</sec:authorize>
			</div>
		</div>
	</div>
	</div>

		  <sec:authorize access="isAuthenticated()">
		  <!-- 게시물 업데이트 모달 박스 영역 -->
					<div class="collection white" id="updateBoardModal" style="display:none; border:2px solid #81c784;">
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
						
							<div id="u_b_description" class="materialize-textarea contentbox"></div>
							
						</div>
						<div class="input-field col s12">
								<div id="u_b_tags" class="tags" data-tags-input-name="tag"></div>
						</div>					
					</div>
				<div class="modal-footer white">
				    <a class="waves-effect waves-light btn-flat" id="updateBoardBtn">수정하기</a>
					<a class="modal-action modal-close waves-effect waves-light btn-flat" onclick="resetUpdateBoardForm();">닫기</a>
				</div>
				</div>			
			</div>
		
		<!-- 답변 업데이트 모달 박스 영역 -->
			<div id="updateCommentModal" class="collection white" style="display:none; border:2px solid #81c784;">
				<div class="collection-item">
					<div class="row">
						<div class="col s12">
				<div class="input-field col s12">
									<div id="u_c_description" class="materialize-textarea contentbox"></div>
								</div>
																<div class="input-field col s12">
								<div id="u_c_tags" class="tags" data-tags-input-name="tag"></div>
				</div>
						</div>					
					</div>
				</div>
				
				<div class="modal-footer white">
				    <a class="waves-effect waves-light btn-flat" id="updateCommentBtn">수정하기</a>
					<a class="modal-action modal-close waves-effect waves-light btn-flat" onclick="resetUpdateCommentForm()">닫기</a>
				</div>
			</div>
		</sec:authorize>
		
		</div>
		<div class="container-fluid">
		
		<!-- 게시물 답변 영역 -->
		<div class="collection" ng-class="{selectedComment:boardContent.selected == comment.id}" dir-paginate="comment in search_contents = (boardContent.comments | filter:searchKeyword | orderBy:'-id') | itemsPerPage:5" pagination-id="commentpage">
			<div class="collection-item">
		    	<span class="chip transparent right"><a class="grey-text">{{comment.created | date:'yyyy년 MM월 dd일 h:mma'}}</a>&nbsp;
		    	<sec:authorize access="isAuthenticated()">
		    	<span ng-if="boardContent.selected == 0 && boardContent.user.id == ${user.id} && ${user.id} != comment.user.id">
		    		<a class="green-text hover" data-ng-click="selectedComment(comment, $index);">선택</a>
		    	</span>
		    	<span ng-if="comment.user.id == ${user.id}">
		    		<a class="blue-text hover" data-ng-click="requestUpdateComment(comment, $index);">수정</a>&nbsp;
		    		<a class="blue-text hover" data-ng-click="requestDeleteComment(comment);">삭제</a>
		    	</span>
		    	</sec:authorize>
		    	</span>
		    	<span class="chip transparent">
					<img ng-src="{{comment.user.thumbnail}}" alt="Contact Person">
					    {{comment.user.nickname}}
				</span>
				<br>
				<div class="">
					<p class="collection-title" ng-bind-html="trustHtml(comment.description)"></p>
				</div>
						    <div class="" ng-if="comment.tags != '[]'">
		    <span class="tags" ng-init="tags=parseJson(comment.tags)">
								<span ng-repeat="tag in tags"><span class="chip red lighten-2 hover white-text" style="border-radius:0;">{{tag}} </span></span>
				</span>
		    </div>
		    </div>

		    </div>
		    <!-- 게시물 답변 페이지네이션 영역 -->
	  	<div class="center-align">
				<dir-pagination-controls
				    max-size="5"
				    template-url="/assets/html/dirPagination.tpl.html"
				    direction-links="true"
  						boundary-links="true"
				    pagination-id="commentpage">
				</dir-pagination-controls>
					
				</div>
		  <sec:authorize access="isAnonymous()">
		  	<div class="collection">
			<div class="collection-item center">
				<a href="/login">로그인</a> 하셔야 답변을 다실 수 있습니다.
			</div>
			</div>
		  </sec:authorize>
		  
		  <sec:authorize access="isAuthenticated()">
		  <!-- 답변 박스 영역 -->	
		<div class="collection col m4 commentbox">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    ${user.nickname}
				</span>
				<div class="row">
			<div class="input-field col s12">
				<div id="c_tags" class="tags" data-tags-input-name="tag"></div>
			</div>
			<div class="input-field col s12">
				<div id="c_description" class="materialize-textarea contentbox"></div>
			</div>
			<div class="center-align">
			<p></p>
			<button id="comment_form_btn" class="btn teal lighten-2 white-text" onclick="comment(${content.id});">답변하기</button>
			</div>
		    </div>
		    </div>
		</div>
		</sec:authorize>
		
	  <div class="center">
	  	<button class="btn red lighten-2" onclick="history.back();">이전으로</button>
	  	<p></p>
	  </div>
	</div>
	</article>
	
	<!-- 버튼 및 로딩 영역 -->
	<div class="fixed-action-btn click-to-toggle">
		<a class="btn-floating btn-large red button-collapse hide-on-large-only" data-activates="nav-mobile">
			<i class="material-icons">web</i>
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
<script src="/assets/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js" integrity="sha384-BLiI7JTZm+JWlgKa0M0kGRpJbF2J8q+qreVrKBC47e3K6BW78kGLrCkeRX6I9RoK" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="/assets/js/tagging.js"></script>
<script src="/assets/js/summernote-ko-KR.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular-loader.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular-sanitize.js"></script>
<script	src="/assets/js/dirPagination.js"></script>
<script src="/assets/js/app.js"></script>
		<sec:authorize access="isAuthenticated()">
		<script>
		$(function() {
			var scope = angular.element(document.getElementById("DetailController")).scope();
			scope.$apply(function(){
				scope.USERID = '${user.id}';
			});
		});
		</script>
		</sec:authorize>
<script type="text/javascript">
var token = $("meta[name='_csrf']").attr("content");
var header = $("meta[name='_csrf_header']").attr("content");

$(function() {
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(header, token);
	});
	getBoardDetail('${content.id}');
	$(".button-collapse").sideNav();
	$('#preloader').hide();
	$('.tags').tagging({
		"no-backspace": true,
		"no-duplicate": true,
	    "no-duplicate-callback": window.alert,
	    "no-duplicate-text": "태그 중복 방지 ->",
	    "forbidden-chars-text": "금지 문자 ->",
	    "forbidden-words-text":"금지 단어 ->",
        "forbidden-chars":[],
        "forbidden-words":[],
		"no-spacebar":true,
		"tags-limit":8,
		"edit-on-delete":false
	});
	initSummernote();
	/**
	 * 단순 메시지 전송을 위함.
	 */
	var stompClient = null;

	function sendMessage(message){
		var scope = angular.element(document.getElementById("DetailController")).scope();
		
		if(stompClient != null)
			stompClient.send("/message/notify/"+scope.boardContent.id, {}, JSON.stringify({'message':$(message).val()}));
		
		$(message).val('');
	}

	$(function() {
		if(document.getElementById("DetailController") != null){
			var scope = angular.element(document.getElementById("DetailController")).scope();
			var socket = new SockJS("/websocket");
			stompClient = Stomp.over(socket);
			stompClient.debug = null;
			stompClient.connect({}, function(frame) {
				stompClient.subscribe('/board/'+scope.boardContent.id, function(response){
					var json = JSON.parse(response.body);
					scope.$apply(function(){
						scope.messages.push(json);
					});
					$("#messagebox").scrollTop($("#messagebox")[0].scrollHeight);
					
				});
			}, function(message){
				$('#message').attr("placeholder","서버와 연결이 끊어짐");
				$('#message').attr("readonly",true);
			});
		}
	});
	
});
</script>
</body>
</html>