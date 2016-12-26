<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>게시판 리스트</title>

<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
	
<!-- Compiled and minified JavaScript -->
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>

<link rel="stylesheet"	href="/assets/css/style.css">
</head>
<body>
	  <nav>
    <div class="nav-wrapper blue lighten-2">
      <a href="#" class="logo">게시판 리스트 만들기 예제</a>
      <ul class="right">
        <li><div class="input-field">
          <input id="search" type="search" required>
          <label for="search"><i class="material-icons">search</i></label>
          <i class="material-icons">close</i>
        </div></li>
        <li><a href="#!">로그인</a></li>
        <li><a class='dropdown-button' href="#!" data-activates='dropdown1'><span class="chip transparent white-text">
					<img src="/assets/img/user-star.png" alt="Contact Person">
					    Jane Doe
				</span></a></li>
      </ul>
        <!-- Dropdown Structure -->
  <ul id='dropdown1' class='dropdown-content'>
    <li><a href="#!">글쓰기</a></li>
    <li><a href="#!">프로필수정</a></li>
    <li class="divider"></li>
    <li><a href="#!">로그아웃</a></li>
  </ul>
    </div>
  </nav>
	<div class="row">
		<div class="col s12 m4 push-m8">
		<div class="collection">
			<div class="collection-item">
		    	<span class="chip transparent">
					<img src="/assets/img/user-star.png" alt="Contact Person">
					    Jane Doe
				</span>
			<div class="row">
			<div class="input-field col s12">
				<input id="q_title" name="q_title" type="text" />
				<label class="active" for="q_title">제목</label>
			</div>
			<div class="input-field col s12">
				<textarea id="q_content" name="q_content" class="materialize-textarea"></textarea>
				<label for="q_content">내용</label>
			</div>
			<div class="input-field col s12">
				<div class="chips chips-placeholder"></div>
			</div>
			<div class="input-field col s12 right-align">
				<a class="waves-effect waves-light btn btn-flat"><i class="material-icons">send</i></a>
			</div>
		</div>
		</div>
	</div>
		  </div>
		  <div class="col s12 m8 pull-m4">
		  <ul class="collection">
		    <li class="collection-item avatar">
		      <img src="/assets/img/user-star.png" alt="" class="circle">
		      <span class="title">작성자</span>
		      <p>
		      	I am a very simple card. I am good at containing small bits of information.
              I am convenient because I require little markup to use effectively.
		      </p>
		      <div class="secondary-content"><a href="#!"><i class="material-icons grey-text text-darken-2">settings</i></a>
		      <a href="#!"><i class="material-icons grey-text text-darken-2">delete_forever</i></a>
		      </div>
		      
		      <p class="right-align"><a href="#"><span class="chip transparent red-text text-lighten-2">답변대기중</span></a><span class="chip transparent">2016년 12월 22일</span></p>
		      
		      <p class="right-align"><span class="chip red lighten-2 white-text">마이바티스</span><span class="chip red lighten-2 white-text">JPA</span></p>
		    </li>
		 </ul>
		 <ul class="collection">
		    <li class="collection-item avatar">
		      <img src="/assets/img/user-star.png" alt="" class="circle">
		      <span class="title">작성자</span>
		      <p>
		      	I am a very simple card. I am good at containing small bits of information.
              I am convenient because I require little markup to use effectively.
		      </p>
		      <div class="secondary-content"><a href="#!"><i class="material-icons grey-text text-darken-2">settings</i></a>
		      <a href="#!"><i class="material-icons grey-text text-darken-2">delete_forever</i></a>
		      </div>
		      <br>
		      <p class="right-align"><a href="#"><span class="chip transparent blue-text text-lighten-2">답변완료</span></a><span class="chip transparent">2016년 12월 22일</span></p>
		      <p class="right-align"><span class="chip red lighten-2 white-text">마이바티스</span><span class="chip red lighten-2 white-text">JPA</span></p>
		    </li>
		  </ul>
	
	</div>
</div>
	<div id="preloader" class="fixed-action-btn">
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
<script type="text/javascript">
$(document).ready(function() {
	$('.chips-placeholder').material_chip({
	    placeholder: 'Enter a tag',
	    secondaryPlaceholder: 'Enter a tag',
	  });
	$('#preloader').hide();
  });
</script>
</body>
</html>