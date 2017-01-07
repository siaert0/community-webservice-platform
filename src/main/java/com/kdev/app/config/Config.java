package com.kdev.app.config;

import javax.servlet.http.HttpSessionListener;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.kdev.app.intercepter.HttpSessionHandler;

@Configuration
public class Config {
	@Bean
	public ModelMapper modelMapper(){
		return new ModelMapper();
	}
	@Bean
	public HttpSessionListener httpSessionListener(){
		return new HttpSessionHandler();
	}
}
