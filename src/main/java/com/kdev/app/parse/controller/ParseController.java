package com.kdev.app.parse.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author K
 * @since 2017-01-15. 10:00
 * @description 에러 키워드 분석 컨트롤러
 */
@Controller
@RequestMapping(value="/parse")
public class ParseController {
	private static final Logger logger = LoggerFactory.getLogger(ParseController.class);
	
	@RequestMapping(value="/error", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> errorParse(@RequestParam("error") String error){
		//주어진 에러내용을 개행과 . ;로 끝나는 문장으로 나눈다.
		String[] errors = error.split("\n|\\.\\s|\\;\\s");
		List<String> errorList = Arrays.asList(errors);
		
		//특정 키워드가 포함된 문자열 필터
		List<String> filtered = errorList.parallelStream().filter(e->{
			Matcher patternN = Pattern.compile("\'.*\'", Pattern.CASE_INSENSITIVE).matcher(e);
			while(patternN.find()){
				String pt = patternN.group();
				if(pt != null)
					return true;
			}
			Matcher pattern = Pattern.compile(".*_jsp.*|.*Exception.*|.*Error.*|.*Not Found.*|.*Did Not.*|.*Failed.*|.*Unable.*|.*Illegal.*|.*Causes.*|.*Rejected.*|.*Occurred.*", Pattern.CASE_INSENSITIVE).matcher(e);
			return pattern.matches();
		 }).collect(Collectors.toList());
		
		List<String> filtered_distinct = new ArrayList<String>();
		
		// 중복제거?
		filtered.forEach(e ->{
			if(!filtered_distinct.contains(e)){
				filtered_distinct.add(e);
			}
		});
		
		//특정 키워드 CSS 적용
		filtered_distinct.parallelStream().forEach(s->{
			int index = filtered_distinct.indexOf(s);
			
			Matcher pattern = Pattern.compile("\'.*?\'", Pattern.CASE_INSENSITIVE).matcher(s);
			while(pattern.find()){
				String pt = pattern.group();
				if(pt != null){
					s = s.replaceAll(pt, "<b class=\"text-success\">"+pt+"</b>");
				}
			}
			
			Matcher pattern_info = Pattern.compile("Cannot|Could not|Not Exist|Not Found|Did not|No Naming", Pattern.CASE_INSENSITIVE).matcher(s);
			while(pattern_info.find()){
				String pt = pattern_info.group();
				if(pt != null){
					s = s.replaceAll(pt, "<b class=\"text-info\">"+pt+"</b>");
				}
			}
			
			Matcher pattern_warning = Pattern.compile("Unable|Invalid|Illegal", Pattern.CASE_INSENSITIVE).matcher(s);
			while(pattern_warning.find()){
				String pt = pattern_warning.group();
				if(pt != null){
					s = s.replaceAll(pt, "<b class=\"text-warning\">"+pt+"</b>");
				}
			}
			
			Matcher pattern_danger = Pattern.compile("Caused by|Causes|Cause|Rejected|Failed", Pattern.CASE_INSENSITIVE).matcher(s);
			while(pattern_danger.find()){
				String pt = pattern_danger.group();
				if(pt != null){
					s = s.replaceAll(pt, "<b class=\"text-danger\">"+pt+"</b>");
				}
			}
			
			Matcher pattern_Required = Pattern.compile("Required", Pattern.CASE_INSENSITIVE).matcher(s);
			s = pattern_Required.replaceAll("<b class=\"text-primary\">Required</b>");
			
			filtered_distinct.set(index, s);
		});

		// 특정 키워드를 제외한 문장을 필터링하여 추천 문장으로 선택한다.
		List<String> recommaned = filtered_distinct.stream().filter(e->{
			Matcher pattern = Pattern.compile(".*Caused by.*", Pattern.CASE_INSENSITIVE).matcher(e);
			Matcher pattern_n = Pattern.compile("\'.*\'", Pattern.CASE_INSENSITIVE).matcher(e);
			Matcher pattern_rc = Pattern.compile(".*_jsp.*|.*Illegal.*|.*Rejected.*|.*Invalid.*|.*Not Exist.*|.*Could not.*|.*Cannot Find.*|.*No Naming.*", Pattern.CASE_INSENSITIVE).matcher(e);
			return (pattern_n.matches() && pattern.matches()) || pattern_rc.matches();
		 }).collect(Collectors.toList());
		
		Map<String, Object> response = new HashMap<String, Object>();
		
		response.put("filtered", filtered_distinct);
		response.put("recommanded",recommaned);
		
		return new ResponseEntity<Object>(response,HttpStatus.ACCEPTED);
	}
	
}