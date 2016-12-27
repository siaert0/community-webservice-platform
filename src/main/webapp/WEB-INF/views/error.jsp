<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>IT Stacks</title>
<!--Import Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!-- Compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">
<link rel="stylesheet"
	href="/assets/css/style.css">
<style>
header, article, footer {
	padding-left: 0;
}
</style>
</head>
<body>
	<article>
		<div class="valign-wrapper" style="width: 100%; height: 100%;">
			<div class="valign center" style="margin: auto;">
					<c:if test="${empty errorcode}">
						<h5>ERROR : 404</h5>
						<h5>Exception : 잘못된 접근</h5>
					</c:if>
					<c:if test="${not empty errorcode}">
						<h5>ERROR : ${errorcode}</h5>
						<h5>Exception : ${exception}</h5>
					</c:if>
					<p>
				<a href="/"
					class="btn-large red waves-effect waves-light">되돌아가기
				</a>
				</p>
			</div>
		</div>
	</article>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<!-- Compiled and minified JavaScript -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
</body>
</html>
