#  Community Webservice Platform
#### *본 프로젝트는 기존 졸업작품을 개선해보기 위하여 2016-12-26일 부터 시작되었습니다.*

## 1. Library Dependencies

> Spring Boot 1.4.3  
> Bootstrap 4 & Materialize & Summernote, tagging.js
> AngularJS 1.6.1  

```xml
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
```

## 기존 졸업작품 프로젝트의 문제점 분석  
- 클라이언트와 서버 애플리케이션의 구조적인 문제점으로 인해 유지보수성이 낮음  
- 사용자 정보를 세션으로 저장하고 검증 인터셉터의 보안적으로 허술한 부분을 보임  
- 자바스크립트 기반의 소셜 로그인으로 인하여 앱키등 보안정보 탈취 가능성 보유  
- 클라이언트의 서비스 기능이 제대로 구현되지 않음  

## 신규 커뮤니티 웹 서비스 플랫폼의 목표  
- 빠른 개발 기간을 위해 스프링 부트 프로젝트를 적용한다.  
- 간단한 설정을 통하여 보다 좋은 보안성을 제공해주는 스프링 시큐리티 프로젝트를 적용한다.  
- 스프링 시큐리티 프로젝트와 연계하여 스프링 소셜 프로젝트로 소셜 로그인 연동 정보를 서버에서 제공받도록 한다.  
- 기존 SQL 맵핑 프레임워크인 MyBatis를 배제하고 표준 자바 퍼시스턴스 기술인 JPA와 함께 스프링 데이터 JPA 프로젝트를 적용하여 효율적으로 객체지향 프로그래밍을 접목한다.  

## 1. Spring Boot Application With JSP
스프링 부트 애플리케이션은 기본적으로 JSP를 사용하기 위한 설정을 권장하지 않는다. 하지만, 스프링 시큐리티 태그 및 JSTL등을 활용하기 위하여 JSP를 사용하기 위한 추가적인 설정을 한다.  

#### 1.1 JSP를 활성화하는데 필요한 의존성 라이브러리를 추가
```xml
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
```

#### 1.2 JSP 활성화를 위한 애플리케이션 프로퍼티 설정  
```text
# JSP
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
spring.mvc.static-path-pattern=/**
```

#### 1.3 JSP 활성화를 위한 애플리케이션 설정  
```java
@SpringBootApplication
public class Application extends SpringBootServletInitializer {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
```

## 2. Domain & Repository    
Domain과 Repository는 스프링 데이터 JPA를 활용한다. 또한, 도메인에 대한 DTO(Data Transfer Object)는 도메인 클래스의 Nested Static Class로 구현한다.  

#### 2.1 도메인 및 DTO를 위한 의존성 라이브러리 추가  
Getter, Setter, ToString, HashCode 작성을 생략하기 위하여 lombok 라이브러리 활용, 도메인과 DTO간 변환을 위한 modelmapper 활용  
```xml
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
```

#### 2.2 Domain  
- 유저 엔터티
```java
@Entity
@Table(name = "USERS")
@Data
public class UserVO {
	@Id
	@Column(name = "USER_ID", length=155)
	private String id;
	
	@Column(name = "USER_EMAIL")
	private String email;
	
	@Column(name = "USER_NICKNAME")
	private String nickname;
	
	@JsonIgnore // JSON으로 응답시에 출력하지 않도록 함
	@Column(name = "USER_PASSWORD")
	private String password;
	
	@Column(name = "USER_THUMBNAIL")
	private String thumbnail;
	
	@Enumerated(EnumType.STRING) // Enum 형식을 사용하는데 String으로 넣겠다.
	@Column(name = "USER_SOCIAL_PROVIDER")
	private SocialProvider socialProvider;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "USER_ROLE")
	private Role role;
	
	@Column(name = "USER_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP) // 컬럼을 Timestamp 형식으로 지정하면서 현재 시간을 넣는다.
	@Column(name="USER_JOINED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date joined;
	
	public boolean isRoleAdmin(){
		return this.role.equals(Role.ROLE_ADMIN);
	}
	
	@Data
	public static class Create{
		@NotBlank
		private String id;
		@Size(min=8)
		@Pattern(regexp="^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$")
		private String password;
		@Email
		private String email;
		@NotBlank
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
	
	@Data
	public static class Update{
		@NotBlank
		private String id;
		@Size(min=8)
		@Pattern(regexp="^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$")
		private String password;
		@Email
		private String email;
		@NotBlank
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
	
	@Data
	public static class EmailCheck{
		@Email
		private String email;
	}
}
```
- 소셜 사용자 커넥션 클래스  
```java
@Embeddable
@Data
public class UserConnectionPK implements Serializable {
	private static final long serialVersionUID = 2246146784504184874L;
	private String userId;
	private String providerId;
	private String providerUserId;
}

@Entity
@Table(name="USERCONNECTION",
		uniqueConstraints = {
			@UniqueConstraint(columnNames = { "userId", "providerId", "providerUserId" }),
			@UniqueConstraint(columnNames = { "userId", "providerId", "rank" }) 
		})
@Data
public class UserConnection {
	@Id
	private UserConnectionPK primaryKey;
	private String accessToken;
	private String displayName;
	private Long expireTime;
	private String imageUrl;
	private String profileUrl;
	private int rank;
	private String refreshToken;
	private String secret;
}
```
- 사용자 정보 클래스  
SocialUser 클래스가 User 클래스를 상속받아 구현되었기 때문에 사용자 정보를 통합할 수 있다.  
```java
@Getter
@Setter
public class SocialUserDetails extends SocialUser {

	private static final long serialVersionUID = 855226823777023437L;

	private String id;
	private String email;
    private String nickname;
    private String thumbnail;
	private String tags;
	private Role role;
    private SocialProvider socialSignInProvider;
 
    public SocialUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }
    
    public SocialUserDetails(UserVO user) {
    	super(user.getEmail(), user.getPassword(), authorities(user));
    	
		this.id = user.getId();
		this.email = user.getEmail();
		this.nickname = user.getNickname();
		this.thumbnail = user.getThumbnail();
		this.tags = user.getTags();
		this.role = user.getRole();
		this.socialSignInProvider = user.getSocialProvider();
    }
    
    public static class Builder {
        private String id;
        private String username;
        private String nickname;
        private String password;
        private String thumbnail;
        private Role role;
        private SocialProvider socialSignInProvider;
        private Set<GrantedAuthority> authorities;
 
        public Builder() {
            this.authorities = new HashSet<>();
        }
 
        public Builder nickName(String nickName) {
            this.nickname = nickName;
            return this;
        }
 
        public Builder id(String id) {
            this.id = id;
            return this;
        }
 
        public Builder password(String password) {
            if (password == null) {
                password = "SocialUser";
            }
            this.password = password;
            return this;
        }
 
        public Builder role(Role role) {
            this.role = role;
            SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role.toString());
            this.authorities.add(authority);
            return this;
        }
 
        public Builder socialSignInProvider(SocialProvider socialSignInProvider) {
            this.socialSignInProvider = socialSignInProvider;
            return this;
        }
 
        public Builder username(String username) {
            this.username = username;
            return this;
        }
        
        public Builder thumbnail(String thumbnail) {
            this.thumbnail = thumbnail;
            return this;
        }
 
        public SocialUserDetails build() {
            SocialUserDetails user = new SocialUserDetails(username, password, authorities);
            user.id = id;
            user.nickname = nickname;
            user.role = role;
            user.socialSignInProvider = socialSignInProvider;
            user.thumbnail = thumbnail;
            return user;
        }
    }
    
	private static Collection<? extends GrantedAuthority> authorities(UserVO userVO) {
		// TODO Auto-generated method stub
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority(userVO.getRole().toString()));
		return authorities;
	}
}
```
- 게시물 엔터티  
```java
@Entity
@Table(name = "BOARDS")
@Data
public class Board {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="BD_ID")
	private int id;
	
	@Column(name="BD_TITLE")
	private String title;
	
	@Column(name="BD_DESCRIPTION", columnDefinition = "TEXT")
	private String description;
	
	@Column(name="BD_CATEGORY")
	private String category;
	
	@Column(name="CM_SELECTED")
	private int selected;
	
	@Column(name="BD_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="BD_CREATED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@ManyToOne
	@JoinColumn(name = "BD_USER_ID", referencedColumnName = "USER_ID")
    private UserVO user;
	
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	@OrderBy("id DESC")
	private Collection<Comment> comments;
	
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	private Collection<Thumb> thumbs;
	
	//Infinity Recursion 방지
    @JsonBackReference
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	private Collection<Scrap> scraps;
    
    @Data
	public static class Create{
		@NotEmpty
		private String title;
		@NotEmpty
		private String category;
		private String description;
		private String tags;
		private UserVO user;
	}
	
	@Data
	public static class Update{
		private int id;
		@NotEmpty
		private String title;
		@NotEmpty
		private String category;
		private String description;
		private String tags;
		private UserVO user;
		private int selected;
		private Date created;
		private Collection<Comment> comments;
	}
}
```
- 댓글 엔터티  
```java
@Entity
@Table(name = "COMMENTS")
@Data
public class Comment {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="CM_ID")
	private int id;
	
	@Column(name="CM_DESCRIPTION", columnDefinition = "TEXT")
	private String description;
	
	@Column(name="CM_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@ManyToOne
	@JoinColumn(name = "CM_USER_ID", referencedColumnName = "USER_ID")
    private UserVO user;
	
	@Column(name = "BD_ID")
	private int board;
	
	@Data
	public static class Create{
		private String description;
		private String tags;
		private UserVO user;
		private int board;
	}
	
	@Data
	public static class Update{
		private int id;
		private String description;
		private String tags;
		private int board;
		private UserVO user;
	}
}
```
- 스크랩 엔터티  
```java
@Embeddable
@Data
public class BOARD_USER_CP_ID implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Column(name = "BD_ID")
	private int boardid;

	@Column(name = "USER_ID")
	private String userid;
}

@Entity
@Table(name="SCRAPS")
@Data
public class Scrap {
    @EmbeddedId
	private BOARD_USER_CP_ID BOARD_USER_CP_ID;
    
    @ManyToOne
    @JoinColumn(name = "BD_ID", insertable=false, updatable=false)
    private Board board;
    
    @ManyToOne
    @JoinColumn(name = "USER_ID", insertable=false, updatable=false)
    private UserVO user;
}
```
- 추천수 엔터티  
```java
@Embeddable
@Data
public class BOARD_USER_CP_ID implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Column(name = "BD_ID")
	private int boardid;

	@Column(name = "USER_ID")
	private String userid;
}


@Entity
@Table(name = "THUMBS")
@Data
public class Thumb {
    @EmbeddedId
	private BOARD_USER_CP_ID BOARD_USER_CP_ID;
    
    @Column(name = "BD_ID", insertable=false, updatable=false)
    private int board;
    
    @ManyToOne
    @JoinColumn(name = "USER_ID", insertable=false, updatable=false)
    private UserVO user;
}
```

#### 2.3 Repository  
Repository는 스프링 데이터 JPA가 제공하는 JpaRepository를 상속받은 인터페이스로 구현한다. 

- 유저 엔터티 리파지토리  
```java
@RepositoryRestResource(collectionResourceRel = "users", path = "users")
public interface UserRepository extends JpaRepository<UserVO, String> {
	public UserVO findByEmail(@Param("email") String email);
	public List<UserVO> findBySocialProvider(@Param("socialProvider") SocialProvider socialProvider);
}
```
- 게시물 엔터티 리파지토리  
```java
public interface BoardRepository extends JpaRepository<Board, Integer>, JpaSpecificationExecutor<Board> {
	@RestResource(exported=false) // REST Prevent
	public void deleteByUser(@Param("user") UserVO userVO);
	public Page<Board> findAllByUser(@Param("user") UserVO userVO, Pageable pageable);
	public Page<Board> findAllByCategory(@Param("category") String category, Pageable pageable);
}
```
- 댓글 엔터티 리파지토리  
```java
public interface CommentRepository extends JpaRepository<Comment, Integer> {
	public void deleteByBoard(int boardid);
	public Page<Comment> findByBoard(Pageable pageable, int boardid);
}
```
- 스크랩 엔터티 리파지토리  
```java
@RepositoryRestResource(exported=false)
public interface ScrapRepository extends JpaRepository<Scrap, BOARD_USER_CP_ID> {
	public Page<Scrap> findByUser(UserVO user, Pageable pageable);
}
```
- 추천수 엔터티 리파지토리  
```java
public interface ThumbRepository extends JpaRepository<Thumb, BOARD_USER_CP_ID> {
	public List<Thumb> findByBoard(int board);
}
```

## 3. Spring Security & Social  
커뮤니티 웹 서비스 플랫폼을 이용하는 사용자의 회원가입 및 로그인은 스프링 소셜과 시큐리티를 연계하여 적용한다. 

#### 3.1 스프링 시큐리티 설정  
```java
@Configuration
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	private UserRepositoryService userRepositoryService;
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		// TODO Auto-generated method stub
		http
		.authorizeRequests()
			.antMatchers("/admin/**").hasRole("ADMIN")
			.antMatchers("/**").permitAll()
		.and()
			.formLogin()
				.loginPage("/login")
				.defaultSuccessUrl("/")
				.successHandler(successHandler())
				.permitAll()
		.and()
			.logout()
				.logoutUrl("/logout")
				.logoutSuccessUrl("/")
		.and()
			.httpBasic();
		
		http.sessionManagement().maximumSessions(1);
	}

	@Override
	public void configure(WebSecurity web) throws Exception {
		// TODO Auto-generated method stub
		web.ignoring()
				.antMatchers("/static/**","/resources/**");
	}
	
	@Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(userRepositoryService).passwordEncoder(passwordEncoder());
    }
	
	@Bean
	public PasswordEncoder passwordEncoder(){
		return new BCryptPasswordEncoder();
	}
    
	@Bean
	public AuthenticationSuccessHandler successHandler(){
		return new LoginAuthenticationSuccessHandler("/");
	}
}
```

#### 3.2 스프링 소셜 설정  
```java
@Configuration
public class SocialConfig implements SocialConfigurer {

	@Autowired
	private DataSource dataSource;
	
	@Override
	public void addConnectionFactories(ConnectionFactoryConfigurer connectionFactoryConfigurer, Environment environment) {
		// TODO Auto-generated method stub	
		connectionFactoryConfigurer.addConnectionFactory(new KakaoConnectionFactory(
	            environment.getProperty("spring.social.kakao.app-id")));
	}
	
	@Override
	public UsersConnectionRepository getUsersConnectionRepository(ConnectionFactoryLocator connectionFactoryLocator) {
		// TODO Auto-generated method stub
		JdbcUsersConnectionRepository repository = new JdbcUsersConnectionRepository(dataSource, connectionFactoryLocator, Encryptors.noOpText());
		return repository;
	}

	@Override
	public UserIdSource getUserIdSource() {
		// TODO Auto-generated method stub
		return new AuthenticationNameUserIdSource();
	}
	
	@Bean
    public ConnectController connectController(
                ConnectionFactoryLocator connectionFactoryLocator,
                ConnectionRepository connectionRepository) {
		SocialConnectController controller = new SocialConnectController(connectionFactoryLocator, connectionRepository);
	        return controller;
    }
	
	@Bean
	@Scope(value="request", proxyMode=ScopedProxyMode.INTERFACES)
	public Facebook facebook(ConnectionRepository repository) {
		Connection<Facebook> connection = repository.findPrimaryConnection(Facebook.class);
		return connection != null ? connection.getApi() : null;
	}
	
	@Bean
	@Scope(value="request", proxyMode=ScopedProxyMode.INTERFACES)
	public Kakao kakao(ConnectionRepository repository) {
		Connection<Kakao> connection = repository.findPrimaryConnection(Kakao.class);
		return connection != null ? connection.getApi() : null;
	}
}
```

## 4. Exception Handling  
에러가 발생하였을 때 JSP로 보여주어야할 경우와 AJAX 요청에 의해서 에러메시지를 반환해주어야할 경우를 나누어서 전역적으로 에러를 처리하도록 하는 방안을 적용한다. AJAX 요청을 확인하는 방법은 ContentType에 X-Requested-With가 존재하는 지를 파악하면 된다. 

```java
@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	private static final String DEFAULT_VIEW = "error";

	public ModelAndView defaultExceptionHandler(HttpServletRequest request, Exception exception){
		ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
		HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
		String reason = annotation.reason();
		
		ExceptionResponse.Builder builder = new ExceptionResponse.Builder();
		ExceptionResponse exceptionResponse = builder.path(request.getRequestURI())
				 .error(reason)
				 .status(httpStatus.name())
				 .exception(exception.getClass().getName())
				 .timestamp(new Date().toString()).build();
		
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
			ExceptionResponse.Builder builder = new ExceptionResponse.Builder();
			ExceptionResponse exceptionResponse = builder.path(request.getRequestURI())
					 .error(exception.getValid())
					 .status(HttpStatus.BAD_GATEWAY.name())
					 .exception(exception.getClass().getName())
					 .timestamp(new Date().toString()).build();
			
			mav.addObject(exceptionResponse);
			return mav;
		}else{
			ResponseStatus annotation = exception.getClass().getAnnotation(ResponseStatus.class);
			HttpStatus httpStatus = HttpStatus.valueOf(annotation.value().value());
			return new ResponseEntity<Object>(exception.getValid(), httpStatus);
		}
	}
}
```

## 6. Service Logic 

#### 6.1 BoardRepositoryService  
게시판 관련 서비스 로직을 통합해서 구현한다.  

```java
@Service
@Transactional //@EnableTransactionManagement
public class BoardRepositoryService {
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private CommentRepository commentRepository;
	
	@Autowired
	private ScrapRepository scrapRepository;
	
	@Autowired
	private ThumbRepository thumbRepository;
	
	@Autowired
	private CategoryRepository categoryRepository;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	/**
	 * ===============================================================
	 * 		BoardRepository
	 * ===============================================================
	 */
	
	public Board createBoard(Board.Create createBoard){
		UserVO userVO = createBoard.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		
		Board createdBoard = boardRepository.save(modelMapper.map(createBoard, Board.class));
		
		if(createdBoard == null)
			throw new NotCreatedException();
			
		return createdBoard;
	}
	
	public Page<Board> findAllBoard(Pageable pageable){
		 return boardRepository.findAll(pageable);
	}
	/**
	 * #검색 및 페이징 기능 개선
	 * And Or연산을 중첩시키는 방법 : Specification
	 */
	public Page<Board> findAll(String search, String category, Pageable pageable){
		return boardRepository.findAll(where(SearchSpec.containTitle(search)).or(SearchSpec.containTags(search)).and(SearchSpec.category(category)), pageable);
	}
	
	public Page<Board> findAllBoardByCategory(String category, Pageable pageable){
		return boardRepository.findAllByCategory(category, pageable);
	}
	
	public Page<Board> findAllBoardByUser(UserVO userVO, Pageable pageable){
		return boardRepository.findAllByUser(userVO, pageable);
	}
	
	public Board updateBoard(Board update){
		return boardRepository.saveAndFlush(update);
	}
	
	public void deleteBoard(int id){
		boardRepository.delete(id);
	}
	
	public Board findBoardOne(int id){
		Board board = boardRepository.findOne(id);
		if(board == null)
			throw new BoardNotFoundException();
		return board;
	}
	public void deleteBoardAllByUser(UserVO userVO){
		boardRepository.deleteByUser(userVO);
	}
	
	/**
	 * ===============================================================
	 * 		CommentRepository
	 * ===============================================================
	 */
	
	public Comment createComment(Comment.Create create){
		UserVO userVO = create.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Not Founded User");
		
		Comment created = commentRepository.save(modelMapper.map(create, Comment.class));
		
		if(created == null)
			throw new NotCreatedException();
		
		return created;
	}
	
	public Comment updateComment(Comment update){
		return commentRepository.saveAndFlush(update);
	}
	
	public void deleteComment(int id){
		commentRepository.delete(id);
	}
	
	public void deleteCommentAll(int boardid){
		commentRepository.deleteByBoard(boardid);
	}
	
	public Comment findCommentOne(int id){
		return commentRepository.findOne(id);
	}
	
	public Page<Comment> findCommentAll(Pageable pageable, int board_id)
	{
		Page<Comment> page = commentRepository.findByBoard(pageable, board_id);
		return page;
	}
	
	public Page<Comment> findCommentAll(Pageable pageable){
		Page<Comment> page = commentRepository.findAll(pageable);
		return page;
	}
	
	/** 
	 *  ===============================================================
	 *  	ThumbRepository
	 *  ===============================================================
	 */ 
	
	public Thumb checkThumb(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		Thumb thumb = thumbRepository.findOne(BOARD_USER_CP_ID);
		
		if(thumb == null){
			thumb = new Thumb();
			thumb.setBOARD_USER_CP_ID(BOARD_USER_CP_ID);
			thumb = thumbRepository.save(thumb);
		}else
			thumbRepository.delete(BOARD_USER_CP_ID);
		
		return thumb;
	}
	
	public List<Thumb> findThumbByBoard(int board){
		return thumbRepository.findByBoard(board);
	}
	
	/** 
	 *  ===============================================================
	 *  	ScrapRepository
	 *  ===============================================================
	 */ 
	
	public Scrap checkScrap(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		Scrap scrap = new Scrap();
			  scrap.setBOARD_USER_CP_ID(BOARD_USER_CP_ID);
		return scrapRepository.save(scrap);
	}
	
	public void deleteScrap(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		scrapRepository.delete(BOARD_USER_CP_ID);
	}
	
	public Page<Scrap> findScrapByUser(UserVO user, Pageable pageable){
		return scrapRepository.findByUser(user, pageable);
	}
	
	/** 
	 *  ===============================================================
	 *  	CategoryRepository
	 *  ===============================================================
	 */
	
	public List<Category> findCategories(){
		return categoryRepository.findAll();
	}
	
	public Category addCategory(Category category){
		categoryRepository.save(category);
		return category;
	}
	
	public Category removeCategory(Category category){
		categoryRepository.delete(category);
		return category;
	}
}
```

#### 6.2 UserRepositoryService  
유저 관련 서비스 로직을 통합해서 구현한다.
```java
@Service
@Transactional
public class UserRepositoryService implements UserDetailsService, SocialUserDetailsService {
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired 
	private PasswordEncoder passwordEncoder;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	public UserVO signInUser(UserVO.Create user){
		UserVO newUser = modelMapper.map(user, UserVO.class);
		newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
		UserVO createdUser = userRepository.save(newUser);
		
		if(createdUser == null)
			throw new NotCreatedException();
		
		return createdUser;
	}
	
	public UserVO findUserByEmail(String email){
		UserVO findUser = userRepository.findByEmail(email);
		return findUser;
	}
	
	public UserVO findUserById(String id){
		UserVO findUser = userRepository.findOne(id);
		return findUser;
	}
	
	public List<UserVO> findAll(){
		return userRepository.findAll();
	}
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		UserVO findUser = findUserByEmail(username);
		if(findUser == null)
			throw new UsernameNotFoundException(username);
		SocialUserDetails userDetails = new SocialUserDetails(findUser);
		return (UserDetails)userDetails;
	}
	
	public UserVO updateUser(UserVO user){
		
		UserVO updatedUser = userRepository.save(user);
		if(updatedUser == null)
			throw new NotUpdatedException();
		
		return updatedUser;
	}
	
	public void withDraw(String id){
		UserVO userVO = userRepository.findOne(id);
		boardRepositoryService.deleteBoardAllByUser(userVO);
		userRepository.delete(userVO);
	}

	@Override
	public SocialUserDetails loadUserByUserId(String userId) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		UserDetails userDetails = this.loadUserByUsername(userId);
		return (SocialUserDetails) userDetails;
	}
}
```

## 7. 구현 과정에서의 해결방안  
신규 커뮤니티 웹 서비스 플랫폼을 구현하면서 발생한 문제점을 어떻게 해결하였는지를 서술한다.  

#### 7.1 Social UserConnection Table Entity  
스프링 시큐리티 예제를 보면 UserConnection 의 테이블을 직접 DDL로 데이터베이스에 만들어두어야 하는 불편함을 보여 스프링 데이터 JPA를 지원을 받아 도메인 엔터티로 구현하였다.  

#### 7.2 Infinity Recursion  
서비스 로직 구현과정에서 도메인 엔터티 간 연관관계에 의해서 Infinity Recursion라는 계속해서 참조해서 가져오는 문제점으로 인하여 스택 오버플로우 에러가 발생하였다. 이를 보완하기 위하여 @JsonBackReference 어노테이션을 명시하여 다시 참조하지 못하도록 제한하였다.  

#### 7.3 Search And Paging Specification  
JPA의 메소드의 이름으로 SQL을 만드는 것이 복잡한 Where연산을 표현할 수 없어 And와 Or에 대한 표현이 제대로 되지 않는 문제점이 발생하여 Specification을 구현해서 연산을 적용할 수 있도록 하였다.  

#### 7.4 AccessDeniedException Handling  
에러를 RuntimeException으로 처리하려고 하려 했으나 AccessDeniedException도 처리함으로 인해 Response is commited 문제점이 발생함을 확인하였다. 그래서 각 에러에 대하여 개별적으로 처리할 수 있도록 변경하였다.  
 
