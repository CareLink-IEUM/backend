package com.ieum.carelink.domain.insurance.dto;

import lombok.Getter;

import java.time.LocalDate;
import java.util.List;

/**
 * 보험 가입 요청 DTO
 * POST /api/insurance/contract
 */
@Getter
public class InsuranceContractRequest {

    private Long memberId;
    private Long productId;
    private String paymentCycle;
    private List<Long> coverageIds;
    private LocalDate startDate;
    private LocalDate endDate;
}