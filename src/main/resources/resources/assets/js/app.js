var app = angular.module('myApp', ['angularUtils.directives.dirPagination']);

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

app.controller('BoardController', function($scope, $http, $log){
	$scope.updateModel = function (data){
		$scope.boardContents = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	$scope.move = function (value){
		location.href="/board/"+value;
	}
	
	getInformation('');
});

app.controller('DetailController', function($scope, $http, $log){
	$scope.updateModel = function (data){
		$scope.boardContent = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
	$scope.requestBoardDelete = function (){
		console.log($scope.boardContent);
		$.ajax({
			type	: 'DELETE',
			url		: '/board/'+$scope.boardContent.id,
			dataType	: 'JSON',
			success	: function(response){
				Materialize.toast("정상적으로 삭제되었습니다.", 3000);
				location.href="/";
			},
			error	: function(response){
				console.log(response);
				alert("오류가 발생하였습니다.", 3000);
			}
		});
	}
	$scope.requestBoardUpdate = function(){
		//모달로 변경합시다.
		$('#u_b_description').val($scope.boardContent.description);
		$('#u_b_title').val($scope.boardContent.title);
		var tags = JSON.parse($scope.boardContent.tags);
		$('#u_b_tags').material_chip({
			data:tags
		});
		Materialize.updateTextFields();
		$("#updateBoardModal").modal('open');
		$("#updateBoardBtn").attr('onclick', '').unbind('click'); 
		$("#updateBoardBtn").attr('onclick', '').click(function(){
			updateBoard($scope.boardContent);
		});
	}
	$scope.requestDelete = function(comment){
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
				console.log(response);
				alert("오류가 발생하였습니다.", 3000);
			}
		});
	}
	$scope.requestUpdate = function(comment, index){
		//모달로 변경합시다.
		$('#u_c_description').val(comment.description);
		var tags = JSON.parse(comment.tags);
		$('#u_c_tags').material_chip({
			data:tags
		});
		Materialize.updateTextFields();
		$('#updateCommentModal').modal('open');
		$("#updateCommentBtn").attr('onclick', '').unbind('click'); 
		$("#updateCommentBtn").attr('onclick', '').click(function(){
			updateComment(comment, index);
		});
	}
});

function getInformation(value){
	var scope = angular.element(document.getElementById("BoardController")).scope();
	var dataObject = {
		category : 	value
	};
	$.ajax({
		type	: 'GET',
		url		: '/board',
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
			console.log(response);
			if(response != "" && response != null){
				scope.$apply(function () {
					scope.updateModel(response.content);
				});
			}
		},
		error	: function(response){
			alert("오류");
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
			console.log(response);
			if(response != "" && response != null){
				scope.$apply(function () {
					scope.updateModel(response);
				});
			}
		},
		error	: function(response){
			alert("오류");
		}
	});
}

function comment(board){
	$('#preloader').show();
	var chips = $('#c_tags').material_chip('data');
	var CommentObject = new Object();
	CommentObject.description = $('#c_description').val();
	CommentObject.tags = JSON.stringify(chips);
	CommentObject.boardid = board;
	$.ajax({
		type	: 'POST',
		url		: '/comment',
		data	: JSON.stringify(CommentObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			$('#c_description').val("");
			$('#c_tags').material_chip({
				data:null
			});
			Materialize.updateTextFields();
			var scope = angular.element(document.getElementById("DetailController")).scope();
			scope.$apply(function () {
				console.log(response);
				scope.boardContent.comments.push(response);
			});
		},
		error : function(response){
			console.log(response);
			alert("오류");
    		}
    	});
	$('#preloader').hide();
}
function updateComment(comment, index){
	$('#preloader').show();
	var chips = $('#u_c_tags').material_chip('data');
	var CommentObject = new Object();
	
	CommentObject.description = $('#u_c_description').val();
	CommentObject.tags = JSON.stringify(chips);
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
				$('#updateCommentModal').modal('close');
			});
		},
		error : function(response){
			console.log(response);
			alert("오류");
    		}
    	});
	$('#preloader').hide();
}
function resetUpdateCommentForm(){
	$('#u_c_description').val('');
	$('#u_c_tags').material_chip({
		data:null
	});
	Materialize.updateTextFields();
}
function updateBoard(board){
	$('#preloader').show();
	var chips = $('#u_b_tags').material_chip('data');
	var BoardObject = new Object();
	BoardObject.title = $('#u_b_title').val();
	BoardObject.description = $('#u_b_description').val();
	BoardObject.tags = JSON.stringify(chips);
	BoardObject.id = board.id;
	BoardObject.category = board.category;
	$.ajax({
		type	: 'POST',
		url		: '/board/'+board.id,
		data	: JSON.stringify(BoardObject),
		contentType: 'application/json',
		dataType	: 'JSON',
		success	: function(response){
			
			var scope = angular.element(document.getElementById("DetailController")).scope();
			scope.$apply(function () {
				scope.boardContent = response;
				resetUpdateBoardForm();
				$('#updateBoardModal').modal('close');
			});
		},
		error : function(response){
			console.log(response);
			alert("오류");
    		}
    	});
	$('#preloader').hide();
}
function resetUpdateBoardForm(){
	$('#u_b_description').val('');
	$('#u_b_tags').material_chip({
		data:null
	});
	Materialize.updateTextFields();
}

