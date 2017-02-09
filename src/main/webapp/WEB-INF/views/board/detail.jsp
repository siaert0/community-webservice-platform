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

<title>Community Webservice Platform</title>

<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css">
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.css" rel="stylesheet">
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
								<div class="col-sm-12">
								<b>카테고리</b>
				<select id="u_b_category" class="browser-default form-control">
			      <option ng-repeat="x in Categories" value="{{x.name}}" ng-selected="boardContent.category=='{{x.name}}'">{{x.name}}</option>
			    </select>
			    <p></p>
			</div>
						<div class="col-sm-12">
							<b>제목</b>
							<input id="u_b_title" name="u_b_title" class="form-control" type="text" />
						<p></p>
						</div>
						<div class="col-sm-12">
							<b>내용</b>
							<div id="u_b_description" class="materialize-textarea contentbox"></div>
						<p></p>
						</div>
						<div class="col-sm-12">
							<b>태그</b>
								<div id="u_b_tags" class="tagging form-control" data-tags-input-name="tag"></div>
						<p></p>
						</div>	
					</div>
					<div class="flex-box">
				    <a class="waves-effect waves-light btn blue lighten-2 white-text btn-full" id="updateBoardBtn">수정하기</a>
					<a class="modal-action modal-close waves-effect waves-light btn red lighten-2 white-text btn-full" data-ng-click="resetUpdateBoardForm();">닫기</a>
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
					<p></p>
				<div class="col-sm-12">
							<b>내용</b>
									<div id="u_c_description" class="materialize-textarea contentbox"></div>
								<p></p>
								</div>
																<div class="col-sm-12">
																<b>태그</b>
								<div id="u_c_tags" class="tagging form-control" data-tags-input-name="tag"></div>
				</div>				
					</div>
					<div class="flex-box">
				    <a class="waves-effect waves-light btn blue lighten-2 white-text btn-full" id="updateCommentBtn" >수정하기</a>
					<a class="modal-action waves-effect waves-light btn red lighten-2 white-text btn-full" data-ng-click="resetUpdateCommentForm()">닫기</a>
				</div>
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
					    <p></p>
				</span>
				<div class="">
					<div class="collection-title" ng-bind-html="trustHtml(comment.description)"></div>
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
		<div class="collection commentbox">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="${user.thumbnail}" alt="Contact Person">
					    <b>${user.nickname}</b>
				</span>
				<div class="row">
				<p></p>
			<div class="col-sm-12">
				<b>내용</b>
				<div id="c_description" class="materialize-textarea contentbox"></div>
				<p></p>
			</div>
			<div class="col-sm-12">
				<b>태그</b>
				<div id="c_tags" class="tagging form-control" data-tags-input-name="tag"></div>
				<p></p>
			</div>
			<div class="col-sm-12">
			<div class="flex-box">
			<button id="comment_form_btn" class="btn teal lighten-2 white-text waves-effect waves-light btn-full" onclick="comment(${content.id});">답변하기</button>
			</div>
			</div>
		    </div>
		    </div>
		</div>
		</sec:authorize>

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
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/summernote.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.2/lang/summernote-ko-KR.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular.min.js"></script>
<script	src="https://code.angularjs.org/1.6.1/angular-sanitize.min.js"></script>
<script src="/assets/js/tagging.js"></script>
<script	src="/assets/js/dirPagination.js"></script>
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
			Materialize.toast("탈퇴하지 못했습니다", 3000);
		}
	});
}

$(function() {
	$('#preloader').hide();
	$('.tagging').tagging({
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
	$('.contentbox').summernote({
		toolbar: [
		          ['pre',['style']],
		          ['style', ['bold', 'italic', 'strikethrough', 'underline', 'clear']],
		          ['font', ['fontname','fontsize']],
		          ['color', ['color']],
		          ['para', ['paragraph'],['height']],
		          ['insert', ['link', 'picture', 'video']],
		          ['misc',['codeview']]
		        ],
		fontNames: ['Noto Sans KR', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
		fontNamesIgnoreCheck: ['Noto Sans KR'],
		lang: 'ko-KR',
		callbacks: {
		    onImageUpload: function(files) {
		    	
		    	for(var i=0; i<files.length; i++){
		    		sendImage(files[i], $(this));
		    	}
		      },
		    onMediaDelete: function(target){
		    	deleteImage(target[0].src);
		    }
		  }
	});
});

/**
 *  에디터 관련 스크립트
 */

function validation(fileName){
    var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1; //.뒤부터 확장자
    var fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex,fileName.length); //확장자 자르기
     
    if( !( (fileNameExtension=='jpg') || (fileNameExtension=='gif') || (fileNameExtension=='png') || (fileNameExtension=='bmp') ) ) {
			Materialize.toast("jpg, gif, png, bmp 확장자만 업로드 가능합니다.",3000,'red',function(){
				
			});
        return true;
    }
    else{
        return false;
    }
}

function sendImage(file, summernote){
	var data = new FormData();
      data.append("Filedata",file);
		$.ajax({
          type: 'POST',
          url: contextPath+'/upload/image/',
          data: data,
        	contentType: false,
     		processData: false,
          dataType: 'JSON', //리턴되는 데이타 타입
          beforeSubmit: function(){
          },
          success: function(fileInfo){
        	  if(fileInfo.result == 1)
        		  $(summernote).summernote('insertImage', fileInfo.imageurl, fileInfo.filename); 
  					Materialize.toast("정상적으로 업로드되었습니다.",3000,'green',function(){
				
			});
          },
          error: function(fileInfo){
        	  if(fileInfo.result==-1){ //서버단에서 체크 후 수행됨
      			Materialize.toast("jpg, gif, png, bmp 확장자만 업로드 가능합니다.",3000,'red',function(){
    				
    			});
                  return false;
              }
              else if(fileInfo.result==-2){ //서버단에서 체크 후 수행됨
      			Materialize.toast("파일이 5MB를 초과하였습니다.",3000,'red',function(){
    				
    			});
                  return false;
              }
          }
      });
    }

function deleteImage(file){
		$.ajax({
          type: 'DELETE',
          url: contextPath+'/upload/image/?url='+file,
          dataType: 'text', //리턴되는 데이타 타입
          beforeSubmit: function(){
          },
          success: function(response){
    			Materialize.toast("정상적으로 삭제되었습니다.",3000,'green',function(){
    				
    			});
          },error: function(response){
      			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
    				console.log(response);
    			});
          }
      });
    }

var app = angular.module('myApp', ['ngSanitize','angularUtils.directives.dirPagination']);

app.controller('DetailController', function($scope, $http, $log, $sce){
	$scope.messages = new Array();
	$scope.isBoardUpdate = false;
	$scope.isCommentUpdate = false;
	$scope.updateCommentIndex = -1;
	
	$scope.updateModel = function (data){
		$scope.boardContent = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	$scope.trustHtml = function(html){
		return $sce.trustAsHtml(html);
	}
	$scope.scrap = function(id){
		var dataObject = new Object();
		dataObject.boardid = id;
		$.ajax({
	        type: 'POST',
	        url: contextPath+'/board/scrap',
	        contentType: 'application/json',
	        data: JSON.stringify(dataObject),
	        dataType: 'TEXT', //리턴되는 데이타 타입
	        success: function(response){
	  			Materialize.toast("스크랩 되었습니다.",3000,'green',function(){
					
				});
	        	
	        },error: function(response){
	  			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
					console.log(response);
				});
	        }
	    });
	}
	
	$scope.checkThumb = function(){
		if($scope.boardContent.thumbs.length > 0){
			var is = false;
			if($scope.USER == ""){
				return 1;
			}
			for(var i=0; i < $scope.boardContent.thumbs.length; i++){
				if($scope.boardContent.thumbs[i].board_USER_CP_ID.userid == $scope.USER.id){
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
	
	$scope.toggleThumb = function(){
		if($scope.USER == ""){
			return;
		}
		var dataObject = new Object();
		dataObject.boardid = $scope.boardContent.id;
		$.ajax({
			type	: 'POST',
			url		: contextPath+'/board/thumb',		
			data	: JSON.stringify(dataObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				if($scope.checkThumb() == 0 || $scope.checkThumb() == 1){
					Materialize.toast("추천 하였습니다",3000,'green',function(){

					});
				}else{
					Materialize.toast("추천을 취소하였습니다",3000,'orange',function(){

					});
				}
				
				$scope.$apply(function(){
					$scope.boardContent.thumbs = response;
				});
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){

				});
			}
		});
	}
	
	$scope.requestBoardDelete = function (){
		if(!confirm("정말 삭제하시겠습니까??")){
			return;
		}
		$.ajax({
			type	: 'DELETE',
			url		: contextPath+'/board/'+$scope.boardContent.id,
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 삭제하였습니다. 잠시후 메인으로 이동합니다",3000,'green',function(){
					location.href="/";
				});
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
					console.log(response);
				});
			}
		});
	}
	
	$scope.requestBoardUpdate = function(){
		$('#board-div').after($('#updateBoardModal'));
		$('#board-div').hide();
		$('#u_b_description').summernote('code', $scope.boardContent.description);
		$('#u_b_title').val($scope.boardContent.title);
		var tags = JSON.parse($scope.boardContent.tags);
		$('#u_b_tags').tagging( "reset" );
		$('#u_b_tags').tagging("add",tags);
		Materialize.updateTextFields();
		$("#updateBoardBtn").attr('onclick', '').unbind('click'); 
		$("#updateBoardBtn").attr('onclick', '').click(function(){
			$scope.updateBoard($scope.boardContent);
		});
		$scope.isBoardUpdate = true;
	}
	
	$scope.updateBoard = function(board){
		$('#preloader').show();
		var BoardObject = new Object();
		BoardObject.title = $('#u_b_title').val();
		BoardObject.description = $('#u_b_description').summernote('code');
		BoardObject.tags = JSON.stringify($('#u_b_tags').tagging("getTags"));
		BoardObject.id = board.id;
		BoardObject.category = $('#u_b_category').val();
		BoardObject.selected = board.selected;
		$.ajax({
			type	: 'POST',
			url		: contextPath+'/board/'+board.id,
			data	: JSON.stringify(BoardObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 수정되었습니다.",3000,'green',function(){

				});
				$scope.$apply(function(){
					$scope.boardContent = response;
				});
				$scope.resetUpdateBoardForm();
			},
			error : function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
					console.log(response);
				});
	    		}
	    	});
		$('#preloader').hide();
	}
	
	$scope.requestDeleteComment = function(comment){
		if(!confirm("정말 삭제하시겠습니까??")){
			return;
		}
		$.ajax({
			type	: 'DELETE',
			url		: contextPath+'/comment/'+comment.id,
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 삭제되었습니다",3000,'green',function(){
					console.log(response);
				});
				var index = $scope.boardContent.comments.indexOf(comment);
				$scope.$apply(function(){
					$scope.boardContent.comments.splice(index, 1);
				});
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
					console.log(response);
				});
			}
		});
	}
	
	$scope.requestUpdateComment = function(comment, index){
		$('#u_c_description').summernote('code',comment.description);
		var tags = JSON.parse(comment.tags);
		$('#u_c_tags').tagging( "reset" );
		$('#u_c_tags').tagging("add",tags);
		Materialize.updateTextFields();
		$("#updateCommentBtn").attr('onclick', '').unbind('click'); 
		$("#updateCommentBtn").attr('onclick', '').click(function(){
			updateComment(comment, index);
		});
		$scope.isCommentUpdate = true;
	}
	
	$scope.selectedComment = function(comment, index){
		var BoardObject = new Object();
		BoardObject.title = $scope.boardContent.title;
		BoardObject.description = $scope.boardContent.description;
		BoardObject.tags = $scope.boardContent.tags;
		BoardObject.id = $scope.boardContent.id;
		BoardObject.category = $scope.boardContent.category;
		
		if($scope.boardContent.selected == 0)
			BoardObject.selected = comment.id;
		else
			BoardObject.selected = 0;

		$.ajax({
			type	: 'POST',
			url		: contextPath+'/board/'+$scope.boardContent.id,
			data 	: JSON.stringify(BoardObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				if(response.selected == 0){
					Materialize.toast("댓글 선택취소",3000,'orange',function(){
						console.log(response);
					});
				}else{
					Materialize.toast("댓글 선택완료",3000,'green',function(){
						console.log(response);
					});
				}
				
				$scope.boardContent = response;
				$scope.$apply();
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
					console.log(response);
				});
			}
		});
	}
	$scope.resetUpdateBoardForm = function(){
		$('#u_b_description').summernote('code','');
		$('#u_b_tags').tagging( "reset" );
		Materialize.updateTextFields();
		$scope.isBoardUpdate = false;
		$('#board-div').show();	
	}
	$scope.resetUpdateCommentForm = function(){
		$('#u_c_description').summernote('code','');
		$('#u_c_tags').tagging( "reset" );
		Materialize.updateTextFields();
		$scope.isCommentUpdate = false;
	}
	$scope.loadDataSet = function(){
		$http({
			method: "GET",
			url : location.pathname
		}).then(function(response){
			$scope.boardContent = response.data;
		},function(response){
			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
				console.log(response);
			});
		});
	}
	$scope.loadUser = function(){
		$http({
			method: "GET",
			url : contextPath+"/user"
		}).then(function(response){
			console.log(response);
			$scope.USER = response.data;
		},function(response){
			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
				console.log(response);
			});
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
	$scope.loadUser();
	$scope.loadDataSet();
});

function comment(board){
	$('#preloader').show();
	var CommentObject = new Object();
	CommentObject.description = $('#c_description').summernote('code');
	CommentObject.tags = JSON.stringify($('#c_tags').tagging("getTags"));
	CommentObject.board = board;
	$.ajax({
		type	: 'POST',
		url		: contextPath+'/comment',
		data	: JSON.stringify(CommentObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			$('#c_description').summernote('code','');
			$('#c_tags').tagging( "reset" );
			Materialize.updateTextFields();
			var scope = angular.element(document.getElementById("DetailController")).scope();
			scope.$apply(function () {
				scope.boardContent.comments.push(response);
			});
			Materialize.toast("정상적으로 댓글이 작성되었습니다.",3000,'green',function(){
				
			});
		},
		error : function(response){
			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
				console.log(response);
			});
    		}
    	});
	$('#preloader').hide();
}
function updateComment(comment, index){
	$('#preloader').show();
	var CommentObject = new Object();
	
	CommentObject.description = $('#u_c_description').summernote('code');
	CommentObject.tags = JSON.stringify($('#u_c_tags').tagging("getTags"));
	CommentObject.id = comment.id;
	CommentObject.board = comment.board;
	$.ajax({
		type	: 'POST',
		url		: contextPath+'/comment/'+comment.id,
		data	: JSON.stringify(CommentObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			
			var scope = angular.element(document.getElementById("DetailController")).scope();
			scope.$apply(function () {
				scope.boardContent.comments[index] = response;
				console.log(scope.boardContent.comments);
				scope.isCommentUpdate = false;
				$('#u_c_description').summernote('code','');
				$('#u_c_tags').tagging( "reset" );
				Materialize.updateTextFields();
				
			});
			Materialize.toast("정상적으로 댓글을 수정하였습니다",3000,'green',function(){
			});
		},
		error : function(response){
			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인해주세요",3000,'red',function(){
				console.log(response);
			});
    		}
    	});
	$('#preloader').hide();
}
</script>
</body>
</html>