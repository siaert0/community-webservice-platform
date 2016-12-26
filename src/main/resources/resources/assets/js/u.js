function checkByEmail(){

	if($('#email').val() == "" || $('#email').val() == null){
		$('#email').focus();
		return;
	}
	
	var dataObject =
	{
		email : $('#email').val()
	};
	
	$.ajax({
		type	: 'GET',
		url		: '/check/email',
		data	: dataObject,
		dataType	: 'JSON',
		success	: function(response){
			console.log("success",response);
			    alert("해당 이메일은 사용가능 합니다.");
		       isEmail = true;
		},
		error : function(response){
			console.log("error",response);
			alert("해당 이메일은 사용 중입니다.");
			$('#email').focus();
			isEmail = false;
    		}
    	});
 }

function register(){
	if(isEmail == false){
		alert("이메일 중복 확인을 하셔야 합니다.");
		return;
	}
	
	if($('#password').val() == "" || $('#password').val() == null){
		alert("패스워드를 반드시 입력해주세요.");
		$('#password').focus();
		return;
	}
	
	var chips = $('#tag').material_chip('data');
	var AuthObject = new Object(); 
	AuthObject.email = $('#email').val();
	AuthObject.password = $('#password').val();
	AuthObject.tags = JSON.stringify(chips);
	
	$.ajax({
		type	: 'POST',
		url		: '/user',
		data	: AuthObject,
		dataType	: 'JSON',
		success	: function(response){
			alert("회원가입 되었습니다.");
			location.href="/login"
		},
		error : function(response){
			console.log(response);
			
    		}
    	});
	
}
function registerAuth(){
	if($('#code').val() == "" || $('#code').val() == null){
		alert("인증코드를 반드시 입력해주세요.");
		$('#code').focus();
		return;
	}
	var AuthObject = new Object(); 
	AuthObject.code = $('#code').val();
	
	$.ajax({
		type	: 'POST',
		url		: '/register/auth',
		data	: AuthObject,
		dataType	: 'JSON',
		success	: function(response){
			alert("인증되었습니다.");
			location.href="/"
		},
		error : function(response){
			alert("해당 인증코드는 올바르지 않습니다.");
			
    		}
    	});
	
}