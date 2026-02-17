error id: file:///C:/Users/shlee/hanwha/2round/backend/src/main/java/com/ieum/carelink/global/config/WebConfig.java:_empty_/CorsRegistry#
file:///C:/Users/shlee/hanwha/2round/backend/src/main/java/com/ieum/carelink/global/config/WebConfig.java
empty definition using pc, found symbol in pc: _empty_/CorsRegistry#
empty definition using semanticdb
empty definition using fallback
non-local guesses:

offset: 384
uri: file:///C:/Users/shlee/hanwha/2round/backend/src/main/java/com/ieum/carelink/global/config/WebConfig.java
text:
```scala
package com.ieum.carelink.global.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegis@@try registry) {
        registry.addMapping("/**") // 모든 경로에 대해
                .allowedOrigins("*") // 모든 출처 허용 (개발 단계라 편하게. 나중엔 프론트 주소만 넣기)
                .allowedMethods("GET", "POST", "PUT", "DELETE") // 허용할 HTTP 메서드
                .maxAge(3000); // 원하는 시간만큼 pre-flight 리퀘스트 캐싱
    }
}
```


#### Short summary: 

empty definition using pc, found symbol in pc: _empty_/CorsRegistry#