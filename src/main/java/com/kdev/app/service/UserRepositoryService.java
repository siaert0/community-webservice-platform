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
import com.kdev.app.repository.UserRepository;

@Service
@Transactional
public class UserRepositoryService implements UserDetailsService {
	
	@Autowired
	UserRepository userRepository;
	
	@Autowired 
	PasswordEncoder passwordEncoder;
	
	@Autowired 
	ModelMapper modelMapper;
	
	@Autowired
	public UserRepositoryService(UserRepository userRepository) {
		// TODO Auto-generated constructor stub
		this.userRepository = userRepository;
	}
	
	public UserVO createUser(UserDTO.Create user){
		UserVO newUser = new UserVO();
		modelMapper.map(user, newUser);
		newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
		UserVO createdUser = userRepository.save(newUser);
		return createdUser;
	}
	
	public UserVO findUserByEmail(String email){
		UserVO findUser = userRepository.findByEmail(email);
		return findUser;
	}
	
	public UserVO findUserById(String id){
		UserVO findUser = userRepository.findById(id);
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
	
	public void delete(String id){
		UserVO userVO = userRepository.findById(id);
		userVO.setEmail(null);
		userRepository.save(userVO);
	}
}
