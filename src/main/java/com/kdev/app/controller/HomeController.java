package com.kdev.app.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kdev.app.repository.UserRepository;

@Controller
public class HomeController {
	private static Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private UserRepository userRepositroy;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public String home(Model model){
		model.addAttribute("userCount", userRepositroy.count());
		model.addAttribute("systemMemory", (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/(1024*1024));
		return "home";
	}
	
	@RequestMapping(value="/board/category/{category}", method = RequestMethod.GET)
	public String category(Model model, @PathVariable String category){
		model.addAttribute("userCount", userRepositroy.count());
		model.addAttribute("systemMemory", (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/(1024*1024));
		model.addAttribute("category", category);
		return "board/list";
	}
	
	@RequestMapping(value = "/sidenav", method = RequestMethod.GET)
	public String sidenav(Model model) {
		return "sidenav";
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpSession session, HttpServletRequest request, Model model) {
		session.setAttribute("redirect", request.getHeader("referer"));
		return "login";
	}

}
