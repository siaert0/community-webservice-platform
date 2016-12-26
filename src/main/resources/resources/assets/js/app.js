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
		window.open("/board/"+value);
	}
	getInformation('');
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