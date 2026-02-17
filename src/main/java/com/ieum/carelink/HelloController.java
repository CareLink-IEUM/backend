package com.ieum.carelink;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
        return "<h1>Carelink 서버 연결 테스트 - 성공</h1>";
    }
}