package com.kdev.app.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.repository.BoardRepository;
import com.kdev.app.repository.UserRepository;
import com.kdev.app.service.UserRepositoryService;

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
	@RequestMapping(value = "/board_list", method = RequestMethod.GET)
	public String board_list(Model model) {
		return "board/list";
	}
}
