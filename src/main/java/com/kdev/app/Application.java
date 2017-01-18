package com.kdev.app;

import org.modelmapper.ModelMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;

/**
 * @package		: com.kdev.app
 * @filename	: Application.java
 * @author		: K
 * @date 		: 2016. 12. 18.
 * @description	: Configuration, EnableAutoConfiguration, ComponentScan
 */
@SpringBootApplication
public class Application extends SpringBootServletInitializer {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
    
    @Bean
	public ModelMapper modelMapper(){
		return new ModelMapper();
	}
}