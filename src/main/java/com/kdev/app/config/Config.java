package com.kdev.app.config;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
public class Config {
	@Bean
	public ModelMapper modelMapper(){
		return new ModelMapper();
	}
}
