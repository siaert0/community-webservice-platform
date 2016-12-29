package com.kdev.app.controller;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.kdev.app.domain.FileVO;
import com.kdev.app.domain.UserVO;
import com.kdev.app.service.UserRepositoryService;

@RestController
@RequestMapping(value="/upload")
@Secured("ROLE_USER")
public class UploadController {
	
	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	
	@RequestMapping(value = "/image", method = RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseEntity<Object> socialUpload(@RequestParam("Filedata") MultipartFile multipartFile, HttpSession httpSession, HttpServletRequest request, Principal principal) throws IOException{
		HashMap<String, Object> fileInfo = new HashMap<String, Object>();
		
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		
	    if(multipartFile != null && !(multipartFile.getOriginalFilename().equals(""))) {
	         
	        // 확장자 제한
	        String originalName = multipartFile.getOriginalFilename(); //실제 파일명
	        String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase(); 
	        if( !( (originalNameExtension.equals("jpg")) || (originalNameExtension.equals("gif")) || (originalNameExtension.equals("png")) || (originalNameExtension.equals("bmp")) ) ){
	            fileInfo.put("result", -1); 
	            new ResponseEntity<Object>(fileInfo, HttpStatus.NOT_ACCEPTABLE);
	        }
	         
	        // 파일크기제한 (5MB)
	        long filesize = multipartFile.getSize(); 
	        long limitFileSize = 5*1024*1024; //5MB
	        if(limitFileSize < filesize){
	            fileInfo.put("result", -2);
	            new ResponseEntity<Object>(fileInfo, HttpStatus.NOT_ACCEPTABLE);
	        }
	         
	        // 저장경로
	        String defaultPath = httpSession.getServletContext().getRealPath("/"); 
	        String path = defaultPath + "upload" + File.separator + "images" + File.separator + "";
	        
	        // 저장경로 처리
	        File file = new File(path);
	        if(!file.exists()) { //디렉토리 존재하지 않을경우 디렉토리 생성
	            file.mkdirs();
	        }
	         
	        // 파일 저장명 처리 (사용자 식별 아이디-20150702091941.확장자)
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	        String today= formatter.format(new Date());
	        String modifyName = userVO.getId()+ "-" + today + "." + originalNameExtension;
	         
	        // 임시저장된 파일을 서버에 저장한다
	        multipartFile.transferTo(new File(path + modifyName));

	        // HashMap에 담아 Callback 합니다.
	        String imageurl = httpSession.getServletContext().getContextPath() + "/upload/images/" + modifyName;
	        
	        fileInfo.put("userid", userVO.getId());
	        fileInfo.put("imageurl", imageurl);     //상대파일경로(사이즈변환이나 변형된 파일)
	        fileInfo.put("originalname", originalName);   //파일명
	        fileInfo.put("filename", modifyName);   //파일명
	        fileInfo.put("filesize", filesize);     //파일사이즈
	        fileInfo.put("fileextension", originalNameExtension);     //파일확장자
	        fileInfo.put("result", 1);
	        
	        // 파일 데이터베이스에 기록할것인가?
	    }
	    return new ResponseEntity<Object>(fileInfo, HttpStatus.CREATED);
	}
	
	@RequestMapping(value = "/image", method = RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseEntity<Object> deleteImage(@RequestParam(value="url") String url, HttpSession httpSession, HttpServletRequest request, Principal principal){
	

		
		String filename = url.substring( url.lastIndexOf('/')+1, url.length() );
		
		String defaultPath = httpSession.getServletContext().getRealPath("/"); 
        String path = defaultPath + "upload" + File.separator + "images" + File.separator + filename;
	    
	    logger.info("{}",filename);
	    logger.info("{}",path);
		File file = new File(path);
		if(!file.exists())
			return new ResponseEntity<Object>("", HttpStatus.NOT_FOUND);
		
		file.delete();
		
		return new ResponseEntity<Object>("", HttpStatus.ACCEPTED);
	}
}
