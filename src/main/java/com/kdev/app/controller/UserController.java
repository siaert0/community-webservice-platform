package com.kdev.app.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.kakao.api.Kakao;
import org.springframework.social.kakao.api.KakaoProfile;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.intercepter.LoginAuthenticationSuccessHandler;
import com.kdev.app.service.UserRepositoryService;

/**
 * @package		: com.kdev.app.controller
 * @filename	: UserController.java
 * @author		: K
 * @date 		: 2016. 12. 20.
 * @description	: 사용자 관련 컨트롤러
 */
@Controller
@SessionAttributes("userProfile")
public class UserController {
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	@Autowired
	private Facebook facebook;
	@Autowired
	private Kakao kakao;
	@Autowired
	private ConnectionRepository connectionRepository;
	@Autowired 
	ModelMapper modelMapper;
	
	@RequestMapping(value="/user/facebook", method= RequestMethod.GET)
	public String FacebookUserView(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) throws Exception{
		Connection<Facebook> connection = connectionRepository.findPrimaryConnection(Facebook.class);
		if (connection == null) {
			return "redirect:/connect/facebook";
		}
		connection.sync();
		String [] fields = { "id","name","birthday","email","location","hometown","gender","first_name","last_name"};
		org.springframework.social.facebook.api.User facebookUser = facebook.fetchObject("me", org.springframework.social.facebook.api.User.class, fields);
		UserDTO.Create user = new UserDTO.Create();
		
		connectionRepository.removeConnection(connection.getKey());
		//가입 여부 확인
		UserVO userVO = userRepositroyService.findUserById(facebookUser.getId());
		if(userVO != null){
			//가입 되었으니까...
			UserDetailsVO userDetailsVO = new UserDetailsVO(userVO);
			Authentication authentication = new UsernamePasswordAuthenticationToken(userDetailsVO, null, userDetailsVO.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(authentication);
			LoginAuthenticationSuccessHandler handler = new LoginAuthenticationSuccessHandler("/");
			handler.onAuthenticationSuccess(request, response, authentication);
		}
		
		user.setId(facebookUser.getId());
		user.setNickname(facebookUser.getName());
		user.setThumbnail("https://graph.facebook.com/"+facebookUser.getId()+"/picture");
		user.setSocialSignInProvider("Facebook");
		user.setRole("ROLE_USER");
		
		model.addAttribute("userProfile", user);
		return "register/form";
	}
	
	@RequestMapping(value="/user/kakao", method= RequestMethod.GET)
	public String KakaoUserView(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) throws Exception{
		Connection<Kakao> connection = connectionRepository.findPrimaryConnection(Kakao.class);
		
		if (connection == null) {
			return "redirect:/connect/kakao";
		}
			
		KakaoProfile KakaoUser = kakao.userOperation().getUserProfile();
		connectionRepository.removeConnection(connection.getKey());
		//가입 여부 확인
		UserVO userVO = userRepositroyService.findUserById(String.valueOf(KakaoUser.getId()));
		
		if(userVO != null){
			//가입 되었으니까...
			UserDetailsVO userDetailsVO = new UserDetailsVO(userVO);
			Authentication authentication = new UsernamePasswordAuthenticationToken(userDetailsVO, null, userDetailsVO.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(authentication);
			LoginAuthenticationSuccessHandler handler = new LoginAuthenticationSuccessHandler("/");
			handler.onAuthenticationSuccess(request, response, authentication);
		}	
		UserDTO.Create user = new UserDTO.Create();
		user.setId(String.valueOf(KakaoUser.getId()));
		user.setNickname(KakaoUser.getProperties().getNickname());
		user.setThumbnail(KakaoUser.getProperties().getThumbnail_image());
		user.setSocialSignInProvider("Kakao");
		user.setRole("ROLE_USER");
		
		kakao.userOperation().logout();
		model.addAttribute("userProfile", user);

		return "register/form";
	}
	
	// 회원정보 생성
	@RequestMapping(value="/user", method= RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createUser(@ModelAttribute("userProfile") @Valid UserDTO.Create user, BindingResult result){
		Map<String, Object> map = new HashMap<String, Object>();
		if(result.hasErrors()){
			map.put("responseMessage", result.getAllErrors().toString());
			return new ResponseEntity<Object>(map,HttpStatus.BAD_REQUEST);
		}
		UserDTO.Transfer newUser = modelMapper.map(userRepositroyService.createUser(user), UserDTO.Transfer.class);
		return new ResponseEntity<Object>(newUser, HttpStatus.CREATED);
	}
	
	//이메일 중복체크
	@RequestMapping(value = "/check/email", method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseEntity<Object> checkByEmail(
			@RequestParam(value = "email", required = true) String email) {
		UserVO user = userRepositroyService.findUserByEmail(email);
		Map<String, Object> map = new HashMap<String, Object>();
		if(user != null){
			map.put("responseMessage", "해당 이메일은 사용중입니다.");
			return new ResponseEntity<Object>(map,HttpStatus.BAD_REQUEST);
		}
		map.put("responseMessage", "해당 이메일은 사용가능 합니다.");
		return new ResponseEntity<Object>(map,HttpStatus.OK);
	}
	@Secured("ROLE_USER")
	@RequestMapping(value="/user/{id}", method = RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> delete(@PathVariable String id, Authentication authentication, HttpSession session){
		UserDetailsVO userDetailsVO = (UserDetailsVO)authentication.getPrincipal();
		if(!userDetailsVO.getId().equals(id)){
			return new ResponseEntity<Object>(HttpStatus.FORBIDDEN);
		}
		userRepositroyService.delete(id);
		SecurityContextHolder.getContext().setAuthentication(null);
		return new ResponseEntity<Object>(HttpStatus.OK);
	}
	
}
