package com.kdev.app.intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import com.kdev.app.exception.badgateway.NotCreatedException;
import com.kdev.app.exception.badgateway.NotUpdatedException;
import com.kdev.app.exception.badgateway.ValidException;
import com.kdev.app.exception.forbidden.ForbiddenException;
import com.kdev.app.exception.notacceptable.EmailDuplicatedException;
import com.kdev.app.exception.notfound.NotFoundException;
import com.kdev.app.exception.notfound.UserNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	private static final String DEFAULT_VIEW = "error";
	private static final String DEFAULT_JSON_VIEW = "jsonView";
	
	/**
	 * AccessDeniedException이 RuntimeException이기 때문에 RuntimeException을 잡아버리면 Response is commited 오류 발생
	 * AccessDeniedException이 발생할 경우 Handler에 의해 로그인 페이지로 리다이렉트 된다.
	 */
	@ExceptionHandler({EmailDuplicatedException.class, ForbiddenException.class, NotCreatedException.class, NotFoundException.class, NotUpdatedException.class, UserNotFoundException.class, ValidException.class})
	public ModelAndView defaultException(HttpServletRequest request, HttpServletResponse response, Exception e){
		ModelAndView mav = null;
		String contentType = request.getHeader("Content-Type");
		if(contentType!=null && !MediaType.APPLICATION_JSON_VALUE.equals(contentType)){
			mav = new ModelAndView(DEFAULT_VIEW);
		}else{
			mav = new ModelAndView(DEFAULT_JSON_VIEW);
		}
		ResponseStatus annotation = e.getClass().getAnnotation(ResponseStatus.class);
		if(annotation != null){
			mav.addObject("errorcode", annotation.value().value());
			mav.addObject("exception", annotation.reason());
		}else{
			mav.addObject("errorcode", e.getCause());
			mav.addObject("exception", e.getMessage());
		}
		return mav;
	}
}
