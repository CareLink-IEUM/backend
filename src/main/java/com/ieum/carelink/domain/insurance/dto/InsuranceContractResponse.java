package com.ieum.carelink.domain.insurance.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.util.List;

/**
 * 보험 가입 결과 DTO
 */
@Getter
@Builder
public class InsuranceContractResponse {

    private Long contractId;
    private Long memberId;
    private Long productId;
    private String productName;
    private String productType;

    private Integer totalPrice;
    private String status;
    private String paymentCycle;

    private LocalDate startDate;
    private LocalDate endDate;

    private List<Long> coverageIds;
}
