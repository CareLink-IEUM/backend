package com.ieum.carelink.domain.insurance.controller;

import com.ieum.carelink.domain.insurance.dto.InsuranceProductCoverageResponse;
import com.ieum.carelink.domain.insurance.service.InsuranceQueryService;
import com.ieum.carelink.global.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ieum.carelink.domain.insurance.dto.InsuranceContractRequest;
import com.ieum.carelink.domain.insurance.dto.InsuranceContractResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.ieum.carelink.domain.insurance.service.InsuranceContractService;

@RestController
@RequestMapping("/api/insurance")
@RequiredArgsConstructor
public class InsuranceController {

    private final InsuranceQueryService insuranceQueryService;
    private final InsuranceContractService insuranceContractService;

    /**
     * productId로 보험 조회
     */
    @GetMapping("/{productId}")
    public ApiResponse<InsuranceProductCoverageResponse> getProductCoverages(@PathVariable Long productId) {
        InsuranceProductCoverageResponse response = insuranceQueryService.getProductCoverages(productId);
        return ApiResponse.success(response);
    }

    /**
     * 보험 확정 (POST)
     */
    @PostMapping("/contract")
    public ApiResponse<InsuranceContractResponse> createContract(@RequestBody InsuranceContractRequest request) {
        InsuranceContractResponse response = insuranceContractService.createContract(request);
        return ApiResponse.success(response);
    }
}