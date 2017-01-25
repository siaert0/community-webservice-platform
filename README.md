#  Community Webservice Platform
#### *본 프로젝트는 기존 졸업작품을 개선해보기 위하여 2016-12-26일 부터 시작되었습니다.*

## 1. Library Dependencies

> Spring Boot 1.4.3  
> Bootstrap 4 & Materialize & Summernote, tagging.js
> AngularJS 1.6.1  
> 현 프로젝트에 적용되는 추가적인 라이브러리 현황은 다음과 같습니다.

## 의존성 라이브러리 목록 ##
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		
		<dependency>
		    <groupId>org.springframework.boot</groupId>
		    <artifactId>spring-boot-starter-websocket</artifactId>
		</dependency>
	
		<!-- Spring Social -->
		<dependency>
			<groupId>org.springframework.social</groupId>
			<artifactId>spring-social-security</artifactId>
		</dependency>
		
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-social-facebook</artifactId>
		</dependency>
		
		<!-- JDBC -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>
		
		<dependency>
			<groupId>com.h2database</groupId>
			<artifactId>h2</artifactId>
			<scope>runtime</scope>
		</dependency>
		
		<!-- Security -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
		
		<dependency>
		    <groupId>org.springframework.security</groupId>
		    <artifactId>spring-security-taglibs</artifactId>
		</dependency>
		
		<dependency>
		    <groupId>org.springframework.security</groupId>
		    <artifactId>spring-security-test</artifactId>
		</dependency>
		
		<!-- ETC -->		
		<dependency>
			<groupId>org.projectlombok</groupId>
			<artifactId>lombok</artifactId>
		</dependency>
		
		<dependency>
		    <groupId>org.modelmapper</groupId>
		    <artifactId>modelmapper</artifactId>
		    <version>0.7.7</version>
		</dependency>
		
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
		
		<!-- JSP / JSTL -->
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>jstl</artifactId>
		</dependency>
		
		<dependency>
			<groupId>org.apache.tomcat.embed</groupId>
			<artifactId>tomcat-embed-jasper</artifactId>
			<scope>provided</scope>
		</dependency>
	</dependencies>

## *Community Webservice Platform Reference*
[레퍼런스 보기](https://kdevkr.github.io/project/2016/12/26/Community-Webservice-Platform-Reference.html)
