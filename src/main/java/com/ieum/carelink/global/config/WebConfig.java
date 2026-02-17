package com.ieum.carelink.global.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // 모든 경로, 모든 출처 허용 (개발용)
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .maxAge(3000);
    }
}