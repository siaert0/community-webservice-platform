package com.kdev.app.exception.handler;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import com.kdev.app.board.exception.BoardNotFoundException;
import com.kdev.app.board.exception.NotCreatedException;
import com.kdev.app.board.exception.NotUpdatedException;
import com.kdev.app.board.exception.ValidErrorException;
import com.kdev.app.exception.domain.ExceptionResponse;
import com.kdev.app.user.exception.EmailDuplicatedException;
import com.kdev.app.user.exception.UserNotEqualException;
import com.kdev.app.user.exception.UserNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	private static final String DEFAULT_VIEW = "error";
	
	/**
	 * AccessDeniedException이 RuntimeException이기 때문에 RuntimeException을 잡아버리면 Response is commited 오류 발생
	 * AccessDeniedException이 발생할 경우 Handler에 의해 로그인 페이지로 리다이렉트 된다.
	 * 
	 * 기존 ContentType 으로 체크하는 방식에서 X-Requested-With 값을 체크하는 것으로 변경.
	 */

	public ModelAndView defaultExceptionHandler(HttpServletRequest request, Exception exception){
		ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
		HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
		String reason = annotation.reason();
		
		ExceptionResponse exceptionResponse = new ExceptionResponse();
		exceptionResponse.setPath(request.getRequestURI());
		exceptionResponse.setStatus(httpStatus.name());
		exceptionResponse.setError(reason);
		exceptionResponse.setException(exception.getClass().getName());
		exceptionResponse.setTimestamp(new Date().toString());
		
		ModelAndView mav = new ModelAndView(DEFAULT_VIEW);
		mav.setStatus(httpStatus);
		mav.addObject(exceptionResponse);
		return mav;
	}
	
	public ResponseEntity<Object> ajaxExceptionHandler(HttpServletRequest request, Exception exception){
		ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
		HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
		String reason = annotation.reason();
		
		ExceptionResponse exceptionResponse = new ExceptionResponse();
		exceptionResponse.setPath(request.getRequestURI());
		exceptionResponse.setStatus(httpStatus.name());
		exceptionResponse.setError(reason);
		exceptionResponse.setException(exception.getClass().getName());
		exceptionResponse.setTimestamp(new Date().toString());
		return new ResponseEntity<Object>(exceptionResponse, httpStatus);
	}
	
	@ExceptionHandler({
		BoardNotFoundException.class, UserNotFoundException.class
		,UserNotEqualException.class
		,NotCreatedException.class, NotUpdatedException.class
		,EmailDuplicatedException.class})
	public Object runtimeException(HttpServletRequest request, HttpServletResponse response, RuntimeException exception){
		String RequestType = request.getHeader("X-Requested-With");
		if(RequestType != null && RequestType.equals("XMLHttpRequest")){
			return ajaxExceptionHandler(request, exception);
		}else{
			return this.defaultExceptionHandler(request, exception);
		}
	}
	
	@ExceptionHandler({ValidErrorException.class})
	public Object validErrorException(HttpServletRequest request, HttpServletResponse response, ValidErrorException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			ModelAndView mav = new ModelAndView(DEFAULT_VIEW);
			mav.setStatus(HttpStatus.BAD_GATEWAY);
			ExceptionResponse exceptionResponse = new ExceptionResponse();
			exceptionResponse.setPath(request.getRequestURI());
			exceptionResponse.setStatus(HttpStatus.BAD_GATEWAY.name());
			exceptionResponse.setError(exception.getValid());
			exceptionResponse.setException(exception.getClass().getName());
			exceptionResponse.setTimestamp(new Date().toString());
			mav.addObject(exceptionResponse);
			return mav;
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception.getValid(), httpStatus);
		}
	}
}
