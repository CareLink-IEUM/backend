package com.ieum.carelink.domain.member.controller;

import com.ieum.carelink.domain.member.dto.PersonalInsuranceContractDto;
import com.ieum.carelink.domain.member.service.MemberPersonalInsuranceService;
import com.ieum.carelink.global.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/members")
@RequiredArgsConstructor
public class MemberPersonalInsuranceController {

    private final MemberPersonalInsuranceService memberPersonalInsuranceService;

    /**
     * 회원의 개인 보험(가입한 보험 계약) 목록 조회
     *
     * 예) GET /api/members/1/personal-insurances?status=ACTIVE
     * status: ACTIVE, EXPIRED, CANCELLED, ALL (기본값: ALL)
     */
    @GetMapping("/{memberId}/personal-insurances")
    public ApiResponse<List<PersonalInsuranceContractDto>> getPersonalInsurances(
            @PathVariable Long memberId,
            @RequestParam(name = "status", defaultValue = "ALL") String status
    ) {
        List<PersonalInsuranceContractDto> result = memberPersonalInsuranceService.getPersonalInsurances(memberId, status);
        return ApiResponse.success(result);
    }
}