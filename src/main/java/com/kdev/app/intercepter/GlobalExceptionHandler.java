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

@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	private static final String DEFAULT_VIEW = "error";
	private static final String DEFAULT_JSON_VIEW = "jsonView";
	
	@ExceptionHandler({Exception.class, RuntimeException.class})
	public ModelAndView defaultException(HttpServletRequest request, HttpServletResponse response, Exception e){
		ModelAndView mav = null;
		String contentType = request.getHeader("Content-Type");
		if(contentType!=null && !MediaType.APPLICATION_JSON_VALUE.equals(contentType)){
			mav = new ModelAndView(DEFAULT_VIEW);
		}else{
			mav = new ModelAndView(DEFAULT_JSON_VIEW);
		}
		ResponseStatus annotation = e.getClass().getAnnotation(ResponseStatus.class);
		mav.addObject("errorcode", annotation.value().value());
		mav.addObject("exception", annotation.reason());
		return mav;
	}
}
