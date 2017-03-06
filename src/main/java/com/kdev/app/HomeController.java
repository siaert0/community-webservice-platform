package com.kdev.app;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.board.domain.Category;

/**
 * <pre>
 * com.kdev.app
 * HomeController.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2016. 12. 18.
 * @updated 2016. 12. 18.
 * @history -
 * ==============================================
 *	뷰 페이지 컨트롤러
 * ==============================================
 */
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
}
