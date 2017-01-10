var app = angular.module('myApp', ['ngSanitize','angularUtils.directives.dirPagination']);

app.directive('krInput', [ '$parse', function($parse) {
    return {
        priority : 2,
        restrict : 'A',
        compile : function(element) {
            element.on('compositionstart', function(e) {
                e.stopImmediatePropagation();
            });
        },
    };
} ]);
app.controller('HomeController', function($scope){
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	getTopInformation();
});

function getTopInformation(){
	var scope = angular.element(document.getElementById("HomeController")).scope();

	$.ajax({
		type	: 'GET',
		url		: '/top',
		dataType	: 'JSON',
		success	: function(response){
			if(response != "" && response != null){
				scope.$apply(function () {
					console.log(response);
					scope.QATopList = response.QA;
					scope.REQURITTopList = response.REQURIT;
					scope.COMMENTTopList = response.COMMENT;
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

/**
 * ####################
 * 관리자 관련 컨트롤러 (관리자 페이지)
 * ####################
 */

app.controller('AdminController', function($scope){
	$scope.searchKeyword = '';
	$scope.pagesize = 5;
	$scope.totalRestrictList = 0;
	
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
			url		: '/restriction',		
			data	: JSON.stringify(dataObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("제재 되었습니다.",3000,'green',function(){
					
				});
				getRestrictList(0, $scope.pagesize, $scope.searchKeyword);
				
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
			url		: '/restriction',		
			data	: JSON.stringify(dataObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("해제되었습니다.",3000,'green',function(){
					
				});
				$scope.$apply(function(){
					$scope.restrictList.splice(index, 1);
				});
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){
					console.log(response);
				});
			}
		});
	}
	
	getRestrictList(0, $scope.pagesize, $scope.searchKeyword);
});

/**
 * ####################
 * 게시판 관련 컨트롤러 (리스트 페이지)
 * ####################
 */

app.controller('BoardController', function($scope, $http, $log, $sce){
	$scope.searchKeyword = '';
	$scope.pagesize = 5;
	$scope.totalElements = 0;
	
	$scope.updateModel = function (data){
		$scope.boardContents = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	$scope.move = function (value){
		location.href="/board/"+value;
	}
	$scope.pageChange = function(page){
		getInformation(category, page, $scope.pagesize, $scope.searchKeyword);
	}
	$scope.searchKeywordChange = function(){
		
		$scope.searchKeyword = $scope.searchText;
		getInformation(category, 0, $scope.pagesize, $scope.searchKeyword);
		console.log($scope.searchKeyword);
	}
	$scope.trustHtml = function(html){
		return $sce.trustAsHtml(html);
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
	getInformation(category, 0, $scope.pagesize, $scope.searchKeyword);
});


/**
 * ####################
 * 스크랩 관련 컨트롤러
 * ####################
 */

app.controller('ScrapController', function($scope, $http){
	$scope.pagesize = 5;
	$scope.totalElements = 0;
	$scope.updateModel = function (data){
		$scope.scraps = data;
	}
	$scope.scrap = function(id, index){
		var scope = angular.element(document.getElementById("ScrapController")).scope();
		delete_scrap(id, index, scope);
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
	getScrap(scrapUser,0,$scope.pagesize);
});

/**
 * ####################
 * 게시판 관련 컨트롤러 (게시물 페이지)
 * ####################
 */

app.controller('DetailController', function($scope, $http, $log, $sce){
	$scope.messages = new Array();
	$scope.messageUserTotal = 0;
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
		var scope = angular.element(document.getElementById("DetailController")).scope();
		check_scrap(id, null, scope);
	}
	$scope.messageUser = function(id){
		$.ajax({
			type	: 'GET',
			url		: '/subscribe/board/'+id,
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				console.log(response);
				$scope.$apply(function(){
					$scope.messageUserTotal = response.length;
				});
			},
			error	: function(response){
				Materialize.toast("오류가 발생하였습니다. 개발자 도구를 확인하세요",3000,'red',function(){

				});
			}
		});
	}
	$scope.checkThumb = function(){
		if($scope.boardContent.thumbs.length > 0){
			var is = false;
			if($scope.USERID == null){
				return 1;
			}
			for(var i=0; i < $scope.boardContent.thumbs.length; i++){
				if($scope.boardContent.thumbs[i].board_USER_CP_ID.userid == $scope.USERID){
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
		if($scope.USERID == null){
			return;
		}
		var dataObject = new Object();
		dataObject.boardid = $scope.boardContent.id;
		$.ajax({
			type	: 'POST',
			url		: '/board/thumb',		
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
			url		: '/board/'+$scope.boardContent.id,
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
			updateBoard($scope.boardContent);
		});
		$scope.isBoardUpdate = true;
	}
	
	$scope.requestDeleteComment = function(comment){
		if(!confirm("정말 삭제하시겠습니까??")){
			return;
		}
		$.ajax({
			type	: 'DELETE',
			url		: '/comment/'+comment.id,
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
		//모달로 변경합시다.
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
			url		: '/board/'+$scope.boardContent.id,
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
});

function getRestrictList(page, size, search){
	var scope = angular.element(document.getElementById("AdminController")).scope();
	var dataObject = {
		page : page,
		size : size,
		search : search
	};
	
	$.ajax({
		type	: 'GET',
		url		: '/restriction',
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
			if(response != "" && response != null){
				scope.$apply(function () {
					scope.totalRestrictList = response.totalElements;
					scope.restrictList = response.content;
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

function getInformation(value, page, size, search){
	var scope = angular.element(document.getElementById("BoardController")).scope();
	var dataObject = {
		category : 	value,
		page : page,
		size : size,
		search : search
	};
	
	$.ajax({
		type	: 'GET',
		url		: '/board',
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
			if(response != "" && response != null){
				console.log(response);
				scope.$apply(function () {
					scope.totalElements = response.page.totalElements;
					scope.updateModel(response.page.content);
					scope.tagList = response.tags;
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

function getScrap(value, page, size){
	var scope = angular.element(document.getElementById("ScrapController")).scope();
	var dataObject = {
		page : page,
		size : size,
	};
	
	$.ajax({
		type	: 'GET',
		url		: '/board/scrap/'+value,
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
			if(response != "" && response != null){
				scope.$apply(function () {
					scope.totalElements = response.totalElements;
					scope.updateModel(response.content);
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

function getBoardDetail(value){
	var scope = angular.element(document.getElementById("DetailController")).scope();
	$.ajax({
		type	: 'GET',
		url		: '/board/'+value,
		dataType	: 'JSON',
		success	: function(response){
			if(response != "" && response != null){
				scope.$apply(function () {
					scope.updateModel(response);
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

function comment(board){
	$('#preloader').show();
	var CommentObject = new Object();
	CommentObject.description = $('#c_description').summernote('code');
	CommentObject.tags = JSON.stringify($('#c_tags').tagging("getTags"));
	CommentObject.board = board;
	$.ajax({
		type	: 'POST',
		url		: '/comment',
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
		url		: '/comment/'+comment.id,
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
				//console.log(response);
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

function updateBoard(board){
	$('#preloader').show();
	var BoardObject = new Object();
	BoardObject.title = $('#u_b_title').val();
	BoardObject.description = $('#u_b_description').summernote('code');
	BoardObject.tags = JSON.stringify($('#u_b_tags').tagging("getTags"));
	BoardObject.id = board.id;
	BoardObject.category = board.category;
	BoardObject.selected = board.selected;
	$.ajax({
		type	: 'POST',
		url		: '/board/'+board.id,
		data	: JSON.stringify(BoardObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			Materialize.toast("정상적으로 수정되었습니다. 잠시후 화면이 갱신됩니다.",3000,'green',function(){
				location.reload();
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
          url: '/upload/image/',
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
          url: '/upload/image/?url='+file,
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

function delete_scrap(id, index, scope){
	var dataObject = new Object();
	dataObject.boardid = id;
	$.ajax({
        type: 'DELETE',
        url: '/board/scrap',
        contentType: 'application/json',
        data: JSON.stringify(dataObject),
        dataType: 'TEXT', //리턴되는 데이타 타입
        success: function(response){
        	scope.$apply(function(){
        		scope.scraps.splice(index, 1);
        	});
  			Materialize.toast("스크랩을 취소하였습니다.",3000,'green',function(){
  				
			});
        	
        },error: function(response){
  			Materialize.toast("오류가 발생하였습니다. 개발자 도구를 통해 확인해주세요",3000,'red',function(){
				console.log(response);
			});
        }
    });
}
function check_scrap(id, index, scope){
	var dataObject = new Object();
	dataObject.boardid = id;
	$.ajax({
        type: 'POST',
        url: '/board/scrap',
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

function initSummernote(){
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
}