package com.kdev.app;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.board.domain.Category;

@Controller
public class HomeController {
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public String home(Model model){
		return "home";
	}
	
	@RequestMapping(value = "/sidenav", method = RequestMethod.GET)
	public String sidenav(Model model) {
		return "sidenav";
	}
	
	@RequestMapping(value="/board/category/{category}", method = RequestMethod.GET)
	public String category(Model model, @PathVariable String category){
		model.addAttribute("category", category);
		return "board/list";
	}
	
	@RequestMapping(value="/parse", method = RequestMethod.GET)
	public String parse(Model model){
		return "parse/home";
	}
}
