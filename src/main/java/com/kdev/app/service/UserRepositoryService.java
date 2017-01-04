package com.kdev.app.service;

import java.util.List;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.exception.NotCreatedException;
import com.kdev.app.repository.UserRepository;

@Service
@Transactional
public class UserRepositoryService implements UserDetailsService {
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired 
	private PasswordEncoder passwordEncoder;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	public UserDTO.Transfer signInUser(UserDTO.Create user){
		UserVO newUser = modelMapper.map(user, UserVO.class);
		newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
		UserVO createdUser = userRepository.save(newUser);
		
		if(createdUser == null)
			throw new NotCreatedException("Failed Create User");
		
		return modelMapper.map(createdUser, UserDTO.Transfer.class);
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
		return new UserDetailsVO(findUser);
	}
	
	public void withDraw(String id){
		UserVO userVO = userRepository.findOne(id);
		boardRepositoryService.deleteBoardAllByUser(userVO);
		userRepository.delete(userVO);
	}
}
