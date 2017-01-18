package com.kdev.app.user.service;

import java.util.List;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.kdev.app.board.exception.NotCreatedException;
import com.kdev.app.board.exception.NotUpdatedException;
import com.kdev.app.board.service.BoardRepositoryService;
import com.kdev.app.user.domain.UserDTO;
import com.kdev.app.user.domain.UserDetailsVO;
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.repositroy.UserRepository;

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
	
	public UserVO signInUser(UserDTO.Create user){
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
		return new UserDetailsVO(findUser);
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
}
