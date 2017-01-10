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

<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css">
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css" rel="stylesheet">
<link rel="stylesheet"  href="${pageContext.request.contextPath}/assets/css/tether.min.css">
<link rel="stylesheet"	href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body id="DetailController" ng-controller="DetailController" ng-cloak>
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
		<c:import url="/sidenav" />
	</header>
	<article style="margin-top:0px;">
	<!-- 게시물 컨트롤러 만들기 -->
	<div class="container-fluid">
	<div class="row">
	<div class="col s12" style="padding:0;">
	<div class="card sticky-action z-depth-0" ng-if="boardContent != null" id="board-div">
		<div class="card-content right-align" style="border-bottom:1px solid #EEE">
		      <span class="chip white left">
			    <img style="height:100%;" ng-src="{{boardContent.user.thumbnail}}">
			    {{boardContent.user.nickname}}
			  </span>
			
			<span class="chip grey darken-2 white-text border-flat">{{boardContent.created | date:'yyyy년 MM월 dd일 h:mma'}}</span>
			<sec:authorize access="isAuthenticated()">
			     <c:if test="${(content.user.id eq user.id) or (user.role eq 'ROLE_ADMIN')}">
				     <span class="chip blue lighten-2 hover white-text border-flat" data-ng-click="requestBoardUpdate();">수정</span>
				     <span class="chip red lighten-2 hover white-text border-flat" data-ng-click="requestBoardDelete();">삭제</span>
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
		 <span class="chip teal lighten-2 white-text border-flat" >{{boardContent.category}}</span>
		 <span class="chip lighten-2 white-text border-flat" ng-class="{blue:boardContent.selected == 0 && boardContent.comments.length > 0, red:boardContent.selected == 0 && boardContent.comments.length == 0, green:boardContent.selected != 0}">댓글 {{boardContent.comments.length}}</span>
		 <span class="chip lighten-2 hover white-text border-flat" ng-class="{red:checkThumb()==0, green:checkThumb()==1, blue:checkThumb()==2}" data-ng-click="toggleThumb();">
		 추천<span ng-if="checkThumb()==1 || checkThumb()==0">하기</span><span ng-if="checkThumb()==2">취소</span> {{boardContent.thumbs.length}}</span>
		 <span class="tags right" ng-if="boardContent.tags != null" ng-init="tags=parseJson(boardContent.tags)">
			<span ng-repeat="tag in tags"><span class="chip red lighten-2 white-text border-flat" style="">{{tag}} </span></span>
		 </span>
		</div>
	</div>
	
	<%-- <div class="collection" style="margin-bottom:0;">
			<div class="collection-item center-align">
				<b>채팅 시스템 (실시간)</b> <span class="right">{{messageUserTotal}}명 참여중</span>
			</div>
			<div id="messagebox" class="collection-item" style="min-height:100px; max-height:100px; overflow:auto; padding-left:10px; padding-right:10px; overflow-wrap:break-word;">
				<p class="" ng-repeat="message in messages">
						      <span class="chip white left">
			    <img style="height:100%;" ng-src="{{message.user.thumbnail}}">
			    {{message.user.nickname}}
			  </span>
				  <span class="chip white border-flat">{{message.message}}</span>
				</p>
			</div>
			<div class="collection-item" style="padding:0.5rem;">
			<sec:authorize access="isAnonymous()">
				<div class="center-align"><a class="hover-black" href="/login">로그인</a> 하고 대화에 참여하기</div>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<input id="message" type="text" class="form-control" style="margin:0;" placeholder="메시지 입력" onkeypress="if(event.keyCode==13) {sendMessage(this); return false;}"/>
			</sec:authorize>
			</div>
		</div> --%>
	</div>
	
	</div>
		  <sec:authorize access="isAuthenticated()">
		  <!-- 게시물 업데이트 모달 박스 영역 -->
					<div class="collection white" id="updateBoardModal" ng-show="isBoardUpdate" style="border:2px solid #81c784;">
			<div class="collection-item">
				<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    <b>${user.nickname}</b>
				</span>
				<p></p>
					<div class="row">
								<div class="col s12">
				<select id="u_b_category" class="browser-default form-control">
			      <option value="" disabled selected>카테고리를 선택해주세요</option>
			      <option value="QA" ng-selected="boardContent.category=='QA'">QA</option>
			      <option value="신입공채" ng-selected="boardContent.category=='신입공채'">신입공채</option>
			    </select>
			</div>
						<div class="input-field col s12">
							<b>제목</b>
							<input id="u_b_title" name="u_b_title" class="form-control" type="text" />
						</div>
						<div class="input-field col s12">
							<b>내용</b>
							<div id="u_b_description" class="materialize-textarea contentbox"></div>
						</div>
						<div class="input-field col s12">
							<b>태그</b>
								<div id="u_b_tags" class="tags form-control" data-tags-input-name="tag"></div>
						</div>					
					</div>
				<div class="modal-footer white">
				    <a class="waves-effect waves-light btn-flat" id="updateBoardBtn">수정하기</a>
					<a class="modal-action modal-close waves-effect waves-light btn-flat" data-ng-click="resetUpdateBoardForm();">닫기</a>
				</div>
				</div>			
			</div>
		
		<!-- 답변 업데이트 모달 박스 영역 -->
			<div id="updateCommentModal" class="collection white" ng-show="isCommentUpdate" style="border:2px solid #81c784;">
				<div class="collection-item">
				<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    <b>${user.nickname}</b>
				</span>
				<p></p>
					<div class="row">
						<div class="col s12">
				<div class="input-field col s12">
							<b>내용</b>
									<div id="u_c_description" class="materialize-textarea contentbox"></div>
								</div>
								<div class="input-field col s12"></div>
																<div class="input-field col s12">
																<b>태그</b>
								<div id="u_c_tags" class="tags form-control" data-tags-input-name="tag"></div>
				</div>
						</div>					
					</div>
				</div>
				
				<div class="modal-footer white">
				    <a class="waves-effect waves-light btn-flat" id="updateCommentBtn" >수정하기</a>
					<a class="modal-action modal-close waves-effect waves-light btn-flat" data-ng-click="resetUpdateCommentForm()">닫기</a>
				</div>
			</div>
		</sec:authorize>
		
		</div>
		<div class="container-fluid">
		<div class="collection" style="border:0;">
			<input id="search" type="text" placeholder="원하는 댓글찾기 ^ㅡ^" required ng-model="searchKeyword" class="form-control" kr-input style="width:100%; height:inherit; padding:1rem .75rem;">	
		</div>

		<!-- 게시물 답변 리스트 영역 -->
		<div id="comment-list" class="collection" ng-class="{selectedComment:boardContent.selected == comment.id}" dir-paginate="comment in search_contents = (boardContent.comments | filter:searchKeyword | orderBy:'-$$hashkey') | itemsPerPage:5" pagination-id="commentpage" ng-show="!isCommentUpdate">
			<div class="collection-item">
		    	<span class="chip transparent right"><a class="chip black-text transparent border-flat">{{comment.created | date:'yyyy년 MM월 dd일 h:mma'}}</a>&nbsp;
		    	<sec:authorize access="isAuthenticated()">
		    	<span ng-if="boardContent.selected == 0 && boardContent.user.id == ${user.id} && ${user.id} != comment.user.id">
		    		<a class="chip green lighten-2 hover white-text border-flat" data-ng-click="selectedComment(comment, $index);">선택</a>
		    	</span>
		    	<span ng-if="boardContent.selected == comment.id && boardContent.user.id == ${user.id} && ${user.id} != comment.user.id">
		    		<a class="chip green lighten-2 hover white-text border-flat" data-ng-click="selectedComment(comment, $index);">선택 취소</a>
		    	</span>
		    	<span ng-if="(comment.user.id == ${user.id} || ${user.role} == 'ROLE_ADMIN')">
		    		<a class="chip blue lighten-2 hover white-text border-flat" data-ng-click="requestUpdateComment(comment, $index);">수정</a>&nbsp;
		    		<a class="chip red lighten-2 hover white-text border-flat" data-ng-click="requestDeleteComment(comment);">삭제</a>
		    	</span>
		    	</sec:authorize>
		    	</span>
		    	<span class="chip transparent">
					<img ng-src="{{comment.user.thumbnail}}" alt="Contact Person">
					    {{comment.user.nickname}}
				</span>
				<div class="">
					<p class="collection-title" ng-bind-html="trustHtml(comment.description)"></p>
				</div>
				
					<div class="" ng-if="comment.tags != '[]'">
					<hr>
	    				<span class="tags" ng-init="tags=parseJson(comment.tags)">
							<span ng-repeat="tag in tags"><span class="chip transparent hover red-text text-lighten-2" style="border-radius:0;">{{tag}} </span></span>
						</span>
		    	</div>
		    </div>

		    </div>
		    <!-- 게시물 답변 페이지네이션 영역 -->
	  	<div class="center-align">
				<dir-pagination-controls
				    max-size="5"
				    template-url="${pageContext.request.contextPath}/assets/html/dirPagination.tpl.html"
				    direction-links="true"
  						boundary-links="true"
				    pagination-id="commentpage">
				</dir-pagination-controls>
					
				</div>
		  <sec:authorize access="isAnonymous()">
		  	<div class="collection">
			<div class="collection-item center">
				<a class="hover-black" href="${pageContext.request.contextPath}/login">로그인</a> 하셔야 답변을 다실 수 있습니다.
			</div>
			</div>
		  </sec:authorize>
		  
		  <sec:authorize access="isAuthenticated()">
		  <!-- 답변 박스 영역 -->	
		<div class="collection col m4 commentbox">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    <b>${user.nickname}</b>
				</span>
				<div class="row">
				<div class="col s12">
				</div>
			<div class="col s12">
				<b>내용</b>
				<div id="c_description" class="materialize-textarea contentbox"></div>
			</div>
			<div class="col s12">
			</div>
			<div class="col s12">
				<b>태그</b>
				<div id="c_tags" class="tags form-control" data-tags-input-name="tag"></div>
			</div>
			<div class="col s12">
			</div>
			<div class="col s12">
			<div class="flex-box">
			<button id="comment_form_btn" class="btn teal lighten-2 white-text btn-full" onclick="comment(${content.id});">답변하기</button>
			</div>
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
<script type="text/javascript">
var token = '${_csrf.token}';
var header = '${_csrf.headerName}';

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
});
/**
 * 단순 메시지 전송을 위함.
 */
/* var stompClient = null;

function sendMessage(message){
	var scope = angular.element(document.getElementById("DetailController")).scope();
	
	if(stompClient != null)
		stompClient.send("/message/notify/"+scope.boardContent.id, {}, JSON.stringify({'message':$(message).val()}));
	
	$(message).val('');
} */

$(function() {
	/* if(document.getElementById("DetailController") != null){
		var scope = angular.element(document.getElementById("DetailController")).scope();
		var socket = new SockJS("/websocket");
		stompClient = Stomp.over(socket);
		stompClient.debug = null;
		stompClient.connect('','',function(frame) {
			if(stompClient != null)
				stompClient.send("/message/notify/"+scope.boardContent.id, {}, JSON.stringify({'message':"님이 채팅에 참여하였습니다"}));
			stompClient.subscribe('/board/'+scope.boardContent.id, function(response){
				console.log(response);
				var json = JSON.parse(response.body);
				scope.$apply(function(){
					scope.messages.push(json);
					scope.messageUserTotal = json.total;
				});
				$("#messagebox").scrollTop($("#messagebox")[0].scrollHeight);
			});
			
		}, function(message){
			$('#message').attr("placeholder","서버와 연결이 끊어짐");
			$('#message').attr("readonly",true);
		});
	} */
});
</script>
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
</body>
</html>