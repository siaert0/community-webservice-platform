<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>스프링 부트</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<link rel="stylesheet" href="/assets/css/style.css">
<style>
header, article, footer {
		    padding-left: 0;
		}
</style>
</head>
<body>
<article>
  <div class="valign-wrapper" style="width:100%; height:100%;">
	  <div class="valign center" style="margin:auto;">
	  <form action="/login" method="post" class="row">
	  <input type="hidden"                        
		name="${_csrf.parameterName}"
		value="${_csrf.token}"/>
		<div class="col s12">
        	<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
        		<p class="red-text">아이디 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요</p>
        	</c:if>
        	<c:if test="${not empty USER_WITHDRAW_EXCEPTION}">
        		<p class="red-text">${USER_WITHDRAW_EXCEPTION}</p>
        	</c:if>
        </div>
        <br>
	    <div class="input-field col s12 l5">
          <input id="username" type="text" name="username" value="" required>
          <label for="username">아이디</label>
        </div>
        <div class="input-field col s12 l5">
          <input id="password" type="password" name="password" value="" required>
          <label for="password">패스워드</label>
        </div>
        <div class="input-field col s12 l2">
           <button type="submit" class="btn red waves-effect waves-light">
      <i class="material-icons">power_settings_new</i>
    </button>
        </div>
        
    	<div class="col s12 l6 center-align">
         
        </div>
    </form>
    </div>
  </div>
  <div class="fixed-action-btn right-align" style="top:5;">
   
				<a class="btn-floating btn-large white waves-effect" href="/">
				<i class="material-icons black-text">close</i>
				</a>
				<br><br>
				<a class="btn light-blue darken-2 waves-effect waves-light" href="/connect/facebook">페이스북으로 회원가입</a><br>
          <a class="btn amber lignten-1 waves-effect waves-light" href="/connect/kakao">카카오톡으로 회원가입</a>
			</div>
</article>
<c:if test="${auth_message != null}">
	<script>
		alert('${auth_message}');
	</script>
</c:if>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script type="text/javascript">
window.onload = function() {
};
</script>
<!-- Compiled and minified JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
</body>
</html>
