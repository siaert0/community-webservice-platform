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
		$scope.boardContent = data;
	}
	$scope.parseJson = function (json) {
        return JSON.parse(json);
    }
});

function getBoardDetail(value){
	var scope = angular.element(document.getElementById("BoardController")).scope();
	console.log(scope);
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