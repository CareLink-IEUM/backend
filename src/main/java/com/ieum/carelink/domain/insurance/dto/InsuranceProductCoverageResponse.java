package com.ieum.carelink.domain.insurance.dto;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class InsuranceProductCoverageResponse {
    private Long productId;
    private String productName;
    private String productType; // MINI, CUSTOM, FIXED
    private String productDescription;
    private List<CoverageDetailDto> coverages;

    @Getter
    @Builder
    public static class CoverageDetailDto {
        private Long coverageId;
        private Long linkId;      // 실제 가입 시에는 linkId가 필요하므로 포함
        private String name;      // 담보명
        private String category;  // 카테고리 (치아, 화재 등)
        private String description;
        private Long amount;      // 보장금액
        private Integer price;    // 월 보험료
        private boolean mandatory; // 필수(Core) 여부
    }
}