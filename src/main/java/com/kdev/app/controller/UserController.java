package com.kdev.app.controller;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
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
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.kakao.api.Kakao;
import org.springframework.social.kakao.api.KakaoProfile;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kdev.app.domain.dto.RestrictionDTO;
import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.pk.PROVIDER_USER_CP_ID;
import com.kdev.app.domain.vo.Restriction;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.enums.SocialProvider;
import com.kdev.app.exception.badgateway.ValidErrorException;
import com.kdev.app.exception.forbidden.UserNotEqualException;
import com.kdev.app.exception.notacceptable.EmailDuplicatedException;
import com.kdev.app.exception.notfound.UserNotFoundException;
import com.kdev.app.intercepter.LoginAuthenticationSuccessHandler;
import com.kdev.app.repository.RestrictionRepository;
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
	private PasswordEncoder passwordEncoder;
	@Autowired 
	private ModelMapper modelMapper;
	@Autowired
	private RestrictionRepository restrictionRepository;
	
	@RequestMapping(value="/signin/facebook", method= RequestMethod.GET)
	public String FacebookUserView(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) throws Exception{
		Connection<Facebook> connection = connectionRepository.findPrimaryConnection(Facebook.class);
		if (connection == null) {
			return "redirect:/connect/facebook";
		}
		String [] fields = { "id","name","birthday","email","location","hometown","gender","first_name","last_name"};
		org.springframework.social.facebook.api.User facebookUser = facebook.fetchObject("me", org.springframework.social.facebook.api.User.class, fields);
		
		connectionRepository.removeConnection(connection.getKey());
		
		//제재여부 확인
		PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID = new PROVIDER_USER_CP_ID();
		PROVIDER_USER_CP_ID.setUserid(facebookUser.getId());
		PROVIDER_USER_CP_ID.setProvider(SocialProvider.Facebook);
		Restriction restriction = restrictionRepository.findOne(PROVIDER_USER_CP_ID);
		
		if(restriction != null)
			return "user/restriction";
		
		UserVO userVO = userRepositroyService.findUserById(facebookUser.getId());
		//가입여부 확인
		if(userVO != null){
			UserDetailsVO userDetailsVO = new UserDetailsVO(userVO);
			Authentication authentication = new UsernamePasswordAuthenticationToken(userDetailsVO, null, userDetailsVO.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(authentication);
			LoginAuthenticationSuccessHandler handler = new LoginAuthenticationSuccessHandler("/");
			handler.onAuthenticationSuccess(request, response, authentication);
		}
		UserDTO.Create user = new UserDTO.Create();
		user.setId(facebookUser.getId());
		user.setNickname(facebookUser.getName());
		user.setThumbnail("https://graph.facebook.com/"+facebookUser.getId()+"/picture");
		user.setSocialSignInProvider(SocialProvider.Facebook);
		user.setRole("ROLE_USER");
		
		model.addAttribute("userProfile", user);
		return "register/form";
	}
	
	@RequestMapping(value="/signin/kakao", method= RequestMethod.GET)
	public String KakaoUserView(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) throws Exception{
		Connection<Kakao> connection = connectionRepository.findPrimaryConnection(Kakao.class);
		if (connection == null) {
			return "redirect:/connect/kakao";
		}
			
		KakaoProfile KakaoUser = kakao.userOperation().getUserProfile();
		connectionRepository.removeConnection(connection.getKey());
		
		//제재여부 확인
		PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID = new PROVIDER_USER_CP_ID();
		PROVIDER_USER_CP_ID.setUserid(String.valueOf(KakaoUser.getId()));
		PROVIDER_USER_CP_ID.setProvider(SocialProvider.Kakao);
		Restriction restriction = restrictionRepository.findOne(PROVIDER_USER_CP_ID);
		
		if(restriction != null)
			return "user/restriction";
		
		UserVO userVO = userRepositroyService.findUserById(String.valueOf(KakaoUser.getId()));
		//가입여부 확인
		if(userVO != null){
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
		user.setSocialSignInProvider(SocialProvider.Kakao);
		user.setRole("ROLE_USER");
		model.addAttribute("userProfile", user);

		return "register/form";
	}
	
	// 회원정보 생성
	@RequestMapping(value="/user", method= RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createUser(@ModelAttribute("userProfile") @Valid UserDTO.Create user, BindingResult result){
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			for(FieldError error : result.getFieldErrors()){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			}
			throw new ValidErrorException(errors.toString());
		}
		UserVO newUser = userRepositroyService.signInUser(user);
		UserDetailsVO userDetailsVO = new UserDetailsVO(newUser);
		Authentication authentication = new UsernamePasswordAuthenticationToken(userDetailsVO, null, userDetailsVO.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);
		return new ResponseEntity<Object>(newUser, HttpStatus.CREATED);
	}
	
	// 회원정보 수정 폼
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/user/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable String id, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		if(!userDetails.getId().equals(id)){
			throw new UserNotEqualException();
		}
		
		return "user/form";
	}
	
	// 회원정보 수정
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/user/{id}", method= RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateUser(@PathVariable String id, @Valid UserDTO.Update user, BindingResult result, Authentication authentication){

		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			for(FieldError error : result.getFieldErrors()){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
				
			throw new ValidErrorException(errors.toString());
			}
		}
		
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		if(!userDetails.getId().equals(id)){
			throw new UserNotEqualException();
		}
		
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		userVO.setPassword(passwordEncoder.encode(user.getPassword()));
		userVO.setNickname(user.getNickname());
		userVO.setTags(user.getTags());
		
		UserVO newUser = userRepositroyService.updateUser(userVO);
		
		UserDetailsVO userDetailsVO = new UserDetailsVO(userVO);
		authentication = new UsernamePasswordAuthenticationToken(userDetailsVO, null, userDetailsVO.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);
		
		return new ResponseEntity<Object>(newUser, HttpStatus.CREATED);
	}
	
	//이메일 중복체크
	@RequestMapping(value = "/check/email", method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseEntity<Object> checkByEmail(
			@Valid UserDTO.EmailCheck email,
			BindingResult result) {
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			for(FieldError error : result.getFieldErrors()){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			}
			throw new ValidErrorException(errors.toString());
		}
		
		UserVO user = userRepositroyService.findUserByEmail(email.getEmail());
		if(user != null){
			throw new EmailDuplicatedException();
		}
		return new ResponseEntity<Object>(email,HttpStatus.OK);
	}
	
	// 회원탈퇴
	@Secured("ROLE_USER")
	@RequestMapping(value="/user/{id}", method = RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> withDraw(@PathVariable String id, Authentication authentication, HttpSession session){
		UserDetailsVO userDetailsVO = (UserDetailsVO)authentication.getPrincipal();
		if(!userDetailsVO.getId().equals(id)){
			throw new UserNotEqualException();
		}
		userRepositroyService.withDraw(id);
		SecurityContextHolder.getContext().setAuthentication(null);
		return new ResponseEntity<Object>(HttpStatus.OK);
	}
	
	@RequestMapping(value = "/user/restriction", method = RequestMethod.GET)
	public String restriction(Model model) {
		return "user/restriction";
	}
}
