package com.kdev.app.intercepter;

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

import com.kdev.app.exception.badgateway.NotCreatedException;
import com.kdev.app.exception.badgateway.NotUpdatedException;
import com.kdev.app.exception.badgateway.ValidErrorException;
import com.kdev.app.exception.forbidden.UserNotEqualException;
import com.kdev.app.exception.notacceptable.EmailDuplicatedException;
import com.kdev.app.exception.notfound.BoardNotFoundException;
import com.kdev.app.exception.notfound.UserNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	private static final String DEFAULT_VIEW = "error";
	private static final String DEFAULT_JSON_VIEW = "jsonView";
	
	/**
	 * AccessDeniedException이 RuntimeException이기 때문에 RuntimeException을 잡아버리면 Response is commited 오류 발생
	 * AccessDeniedException이 발생할 경우 Handler에 의해 로그인 페이지로 리다이렉트 된다.
	 * 
	 * 기존 ContentType 으로 체크하는 방식에서 X-Requested-With 값을 체크하는 것으로 변경.
	 */

	public ModelAndView defaultExceptionHandler(Exception e){
		ResponseStatus annotation = e.getClass().getAnnotation(ResponseStatus.class);
		HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
		String reason = annotation.reason();
		
		ModelAndView mav = new ModelAndView(DEFAULT_VIEW);
		mav.setStatus(httpStatus);
		mav.addObject("errorcode", httpStatus);
		mav.addObject("exception", reason);
		return mav;
	}
	
	@ExceptionHandler({BoardNotFoundException.class})
	public Object boardNotFoundException(HttpServletRequest request, HttpServletResponse response, BoardNotFoundException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception, httpStatus);
		}
	}
	
	@ExceptionHandler({UserNotFoundException.class})
	public Object userNotFoundException(HttpServletRequest request, HttpServletResponse response, UserNotFoundException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception, httpStatus);
		}
	}
	
	@ExceptionHandler({UserNotEqualException.class})
	public Object userNotEqualException(HttpServletRequest request, HttpServletResponse response, UserNotEqualException exception){
		String RequestType = request.getHeader("X-Requested-With");
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception, httpStatus);
		}
	}
	
	@ExceptionHandler({NotCreatedException.class})
	public Object notCreatedException(HttpServletRequest request, HttpServletResponse response, NotCreatedException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception, httpStatus);
		}
	}
	
	@ExceptionHandler({NotUpdatedException.class})
	public Object notUpdatedException(HttpServletRequest request, HttpServletResponse response, NotUpdatedException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception, httpStatus);
		}
	}
	
	@ExceptionHandler({EmailDuplicatedException.class})
	public Object emailDuplicatedException(HttpServletRequest request, HttpServletResponse response, EmailDuplicatedException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>("이메일이 중복됩니다", httpStatus);
		}
	}
	
	@ExceptionHandler({ValidErrorException.class})
	public Object validErrorException(HttpServletRequest request, HttpServletResponse response, ValidErrorException exception){
		String RequestType = request.getHeader("X-Requested-With");	
		if(RequestType != null && !RequestType.equals("XMLHttpRequest")){
			return this.defaultExceptionHandler(exception);
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception.getValid(), httpStatus);
		}
	}
}
