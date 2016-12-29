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

app.controller('BoardController', function($scope, $http, $log, $sce){
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
		getInformation(category,page,$scope.pagesize);
	}
	$scope.trustHtml = function(html){
		return $sce.trustAsHtml(html);
	}
	
	getInformation(category,0,$scope.pagesize);
});

app.controller('DetailController', function($scope, $http, $log, $sce){
	$scope.updateModel = function (data){
		$scope.boardContent = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	$scope.trustHtml = function(html){
		return $sce.trustAsHtml(html);
	}
	$scope.requestBoardDelete = function (){
		$.ajax({
			type	: 'DELETE',
			url		: '/board/'+$scope.boardContent.id,
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 삭제되었습니다.", 3000);
				location.href="/";
			},
			error	: function(response){
				Materialize.toast("삭제하지 못했습니다", 3000);
			}
		});
	}
	$scope.requestBoardUpdate = function(){
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
		$('#updateBoardModal').show();
	}
	$scope.requestDeleteComment = function(comment){
		$.ajax({
			type	: 'DELETE',
			url		: '/comment/'+comment.id,
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 삭제되었습니다.", 3000);
				var index = $scope.boardContent.comments.indexOf(comment);
				$scope.boardContent.comments.splice(index, 1);
				$scope.$apply();
			},
			error	: function(response){
				Materialize.toast("삭제하지 못했네요", 3000);
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
		$('#updateCommentModal').show();
	}
	
	$scope.selectedComment = function(comment, index){
		var BoardObject = new Object();
		BoardObject.title = $scope.boardContent.title;
		BoardObject.description = $scope.boardContent.description;
		BoardObject.tags = $scope.boardContent.tags;
		BoardObject.id = $scope.boardContent.id;
		BoardObject.category = $scope.boardContent.category;
		BoardObject.selected = comment.id;

		$.ajax({
			type	: 'POST',
			url		: '/board/'+$scope.boardContent.id,
			data 	: JSON.stringify(BoardObject),
			contentType: 'application/json',
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 선택되었습니다.", 3000);
				$scope.boardContent = response;
				$scope.$apply();
			},
			error	: function(response){
				Materialize.toast("처리되지 못했네요", 3000);
			}
		});
	}
	
});

function getInformation(value, page, size){
	var scope = angular.element(document.getElementById("BoardController")).scope();
	var dataObject = {
		category : 	value,
		page : page,
		size : size,
	};
	
	$.ajax({
		type	: 'GET',
		url		: '/board',
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
			Materialize.toast("정보를 가져오지 못했네요", 3000);
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
			Materialize.toast("정보를 가져오지 못했네요", 3000);
		}
	});
}

function comment(board){
	$('#preloader').show();
	var CommentObject = new Object();
	CommentObject.description = $('#c_description').summernote('code');
	CommentObject.tags = JSON.stringify($('#c_tags').tagging("getTags"));
	CommentObject.boardid = board;
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
			Materialize.toast("정상적으로 등록되었습니다.", 3000);
		},
		error : function(response){
			Materialize.toast("수정할 수 없었습니다.", 3000);
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
	CommentObject.boardid = comment.boardid;
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
				resetUpdateCommentForm();
				$('#updateCommentModal').modal('hide');
			});
			Materialize.toast("정상적으로 수정되었습니다.", 3000);
		},
		error : function(response){
			Materialize.toast("수정할 수 없었습니다.", 3000);
    		}
    	});
	$('#preloader').hide();
}
function resetUpdateCommentForm(){
	$('#u_c_description').summernote('code','');
	$('#u_c_tags').tagging( "reset" );
	Materialize.updateTextFields();
	$('#updateCommentModal').hide();
}
function updateBoard(board){
	$('#preloader').show();
	var BoardObject = new Object();
	BoardObject.title = $('#u_b_title').val();
	BoardObject.description = $('#u_b_description').val();
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
			location.reload();
		},
		error : function(response){
			Materialize.toast("수정할 수 없었습니다.", 3000);
    		}
    	});
	$('#preloader').hide();
}
function resetUpdateBoardForm(){
	$('#u_b_description').summernote('code','');
	$('#u_b_tags').tagging( "reset" );
	Materialize.updateTextFields();
	$('#updateBoardModal').hide();
}

function validation(fileName){
    var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1; //.뒤부터 확장자
    var fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex,fileName.length); //확장자 자르기
     
    if( !( (fileNameExtension=='jpg') || (fileNameExtension=='gif') || (fileNameExtension=='png') || (fileNameExtension=='bmp') ) ) {
        alert('jpg, gif, png, bmp 확장자만 업로드 가능합니다.');
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
        	  Materialize.toast("정상적으로 업로드되었습니다.", 3000);
          },
          error: function(fileInfo){
        	  if(fileInfo.result==-1){ //서버단에서 체크 후 수행됨
                  alert('jpg, gif, png, bmp 확장자만 업로드 가능합니다.');
                  return false;
              }
              else if(fileInfo.result==-2){ //서버단에서 체크 후 수행됨
                  alert('파일이 5MB를 초과하였습니다.');
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
        	  Materialize.toast("정상적으로 삭제되었습니다.", 3000);
          }
      });
    }
$(function() {
// 로딩 후 호출됨

	$('.contentbox').summernote({
		toolbar: [
		          // [groupName, [list of button]]
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
		    	sendImage(files[0], $(this));
		      },
		    onMediaDelete: function(target){
		    	deleteImage(target[0].src);
		    }
		  }
	});
});