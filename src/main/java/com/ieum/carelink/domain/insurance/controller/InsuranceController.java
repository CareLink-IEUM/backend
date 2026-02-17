package com.ieum.carelink.domain.insurance.controller;

import com.ieum.carelink.domain.insurance.dto.InsuranceProductCoverageResponse;
import com.ieum.carelink.domain.insurance.service.InsuranceQueryService;
import com.ieum.carelink.global.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/insurance")
@RequiredArgsConstructor
public class InsuranceController {

    private final InsuranceQueryService insuranceQueryService;

    @GetMapping("/{productId}")
    public ApiResponse<InsuranceProductCoverageResponse> getProductCoverages(@PathVariable Long productId) {
        InsuranceProductCoverageResponse response = insuranceQueryService.getProductCoverages(productId);
        return ApiResponse.success(response);
    }
}