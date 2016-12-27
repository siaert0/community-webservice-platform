package com.kdev.app.controller;

import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.exception.BoardNotFoundException;
import com.kdev.app.exception.UserNotFoundException;
import com.kdev.app.repository.BoardRepository;
import com.kdev.app.repository.UserRepository;

@Controller
public class HomeController {
	private static Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private UserRepository userRepositroy;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public String home(Model model){
		model.addAttribute("userCount", userRepositroy.count());
		model.addAttribute("boardCount", boardRepository.count());
		model.addAttribute("systemMemory", (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/(1024*1024));
		return "home";
	}
	
	@RequestMapping(value = "/sidenav", method = RequestMethod.GET)
	public String sidenav() {
		return "sidenav";
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model) {
		return "login";
	}
	
	@RequestMapping(value = "/board_view", method = RequestMethod.GET)
	public String board_view(Model model) {
		return "board/detail";
	}
	@RequestMapping(value = "/usernot", method = RequestMethod.GET)
	public String usernot(Model model) {
		throw new UserNotFoundException("테스트");
	}
	@RequestMapping(value = "/boarnot", method = RequestMethod.GET)
	public String boardnot(Model model) throws SQLException {
		throw new BoardNotFoundException("테스트");
	}
}
