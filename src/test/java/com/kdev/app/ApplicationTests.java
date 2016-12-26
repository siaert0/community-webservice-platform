package com.kdev.app;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.logout;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.authenticated;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.unauthenticated;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kdev.app.domain.BoardDTO;
import com.kdev.app.domain.UserDTO;
import com.kdev.app.domain.UserVO;
import com.kdev.app.repository.BoardRepository;
import com.kdev.app.repository.UserRepository;
import com.kdev.app.service.UserRepositoryService;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes=Application.class)
@WebAppConfiguration
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ApplicationTests {

	@Autowired
	UserRepository userRepository;
	
	@Autowired
	BoardRepository boardRepository;
	
	@Autowired
	WebApplicationContext webApplicationContext;
	
	@Autowired
	ObjectMapper objectMapper;

	MockMvc mockMvc;
	
	@Autowired
	UserRepositoryService userRepositoryService;
	
	Authentication authentication;
	
	/**
	 * @author		: K
	 * @method		: setUp
	 * @description	: 애플리케이션컨텍스트를 설정하고 스프링 시큐리티를 적용한다.
	 */
	@Before
	public void setUp(){
		this.mockMvc = MockMvcBuilders
				.webAppContextSetup(webApplicationContext)
				.apply(springSecurity())
				.build();
		
		List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList("ROLE_USER");
	    authentication = 
	        new UsernamePasswordAuthenticationToken("kdevkr@gmail.com","1234", authorities);
	    SecurityContextHolder.getContext().setAuthentication(authentication);
	}
	
	@Test
	public void Step1_contextLoads() throws Exception{
		ResultActions result = mockMvc.perform(get("/"));
		result.andExpect(status().isOk());
	}
	
	/**
	 * @author		: K
	 * @method		: createUserTest
	 * @description	: CSRF 토큰 설정과 sessionAttribute에 유저정보를 설정하여 계정을 생성하는 테스트를 진행한다.
	 */
	
	@Test
	public void Step2_createUserTest() throws Exception{
		UserDTO.Create user = new UserDTO.Create();
		user.setId("230032464093191");
		user.setEmail("kdevkr@gmail.com");
		user.setPassword("1234");
		user.setNickname("Kr Kdev");
		user.setRole("ROLE_USER");
		user.setSocialSignInProvider("Facebook");
		user.setThumbnail("https://graph.facebook.com/230032464093191/picture");
		
		ResultActions result = mockMvc.perform(
				post("/user").with(csrf())
				.contentType(MediaType.APPLICATION_JSON)
				.sessionAttr("userProfile", user
			));
		
		result.andDo(print());
	}

	/**
	 * @author		: K
	 * @method		: loginTest
	 * @description	: 스프링 시큐리티가 제공하는 formlogin을 통한 로그인 처리결과를 확인한다.
	 * 				  authenticated()는 인증정보가 포함되어 있는지 여부를 확인한다.
	 */
	@Test
	public void Step3_loginTest() throws Exception {
		ResultActions result = mockMvc.perform(
				formLogin("/login")
				.user("kdevkr@gmail.com")
				.password("1234"));
		
		result.andExpect(authenticated());
	}
	
	
	// TODO: 게시물 만들고 반환되는 정보 확인. 
	@Test
	public void Step4_boardCreateTest() throws Exception{
		BoardDTO.Create createBoard = new BoardDTO.Create();
		createBoard.setTitle("제목");
		createBoard.setCategory("카테고리");
		createBoard.setDescription("내용");
		createBoard.setTags("태그");
		UserVO user = new UserVO();
		user.setId("230032464093191");
		user.setEmail("kdevkr@gmail.com");
		user.setNickname("Kr Kdev");
		createBoard.setUser(user);
		
		ResultActions result = mockMvc.perform(
				post("/board").with(csrf())
				.contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(createBoard))
			);
		
		result.andDo(print());
		result.andExpect(status().isCreated());
		
		createBoard.setTitle("제목2");
		createBoard.setCategory("카테고리2");
		createBoard.setDescription("내용2");
		createBoard.setTags("태그2");
		
		user = new UserVO();
		user.setId("230032464093191");
		user.setEmail("kdevkr@gmail.com");
		user.setNickname("Kr Kdev");
		createBoard.setUser(user);
		
		result = mockMvc.perform(
				post("/board").with(csrf())
				.contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(createBoard))
			);
		
		result.andDo(print());
		result.andExpect(status().isCreated());
	}
	
	@Test
	public void Step5_boardUpdateTest() throws Exception{
		BoardDTO.Update updateBoard = new BoardDTO.Update();
		updateBoard.setTitle("제목3");
		updateBoard.setCategory("카테고리3");
		updateBoard.setDescription("내용3");
		updateBoard.setTags("태그3");
		
		ResultActions result = mockMvc.perform(
				post("/board/1").with(csrf())
				.contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(updateBoard))
			);
		
		result.andDo(print());
		result.andExpect(status().isAccepted());
	}
	
	@Test
	public void Step6_boardDeleteTest() throws Exception{
		
		ResultActions result = mockMvc.perform(
				delete("/board/1").with(csrf())
				.contentType(MediaType.APPLICATION_JSON)
				
			);
		
		result.andDo(print());
		result.andExpect(status().isAccepted());
	}
	
	@Test
	public void Step5_boardFindTest() throws Exception{		
		ResultActions result = mockMvc.perform(
				get("/board")
				.contentType(MediaType.APPLICATION_JSON)
			);
		
		result.andDo(print());
		result.andExpect(status().isAccepted());
	}
	
	@Test
	public void Step5_boardFindUserVOTest() throws Exception{		
		ResultActions result = mockMvc.perform(
				get("/board/me/"+"230032464093191")
				.param("page", "0")
				.param("size", "5")
				.contentType(MediaType.APPLICATION_JSON)
			);
		
		result.andDo(print());
		result.andExpect(status().isAccepted());
	}
	
	/**
	 * @author		: K
	 * @method		: logoutTest
	 * @description	: 마지막으로 로그아웃을 확인한다.
	 */
	@Test
	public void Step7_logoutTest() throws Exception {
		ResultActions result = mockMvc.perform(logout());
		result.andExpect(unauthenticated()); 
	}
}
