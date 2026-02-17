package com.ieum.carelink.global.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ApiResponse<T> {

    private boolean success;
    private String message;
    private T data;

    // 성공 + 데이터 있음
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "요청 성공", data);
    }

    // 성공 + 데이터 없음
    public static <T> ApiResponse<T> success() {
        return new ApiResponse<>(true, "요청 성공", null);
    }

    // 실패
    public static <T> ApiResponse<T> fail(String message) {
        return new ApiResponse<>(false, message, null);
    }
}