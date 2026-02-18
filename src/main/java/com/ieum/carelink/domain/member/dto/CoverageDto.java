package com.ieum.carelink.domain.member.dto;

import com.ieum.carelink.domain.insurance.entity.ProductCoverageLink;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CoverageDto {

    private Long coverageId;
    private String name;
    private String category;
    private Long amount;
    private Integer monthlyPrice;
    private Boolean mandatory;
    private Boolean recommended;

    public static CoverageDto from(ProductCoverageLink link) {
        return CoverageDto.builder()
                .coverageId(link.getCoverage().getId())
                .name(link.getCoverage().getName())
                .category(link.getCoverage().getCategory())
                .amount(link.getAmount())
                .monthlyPrice(link.getMonthlyPrice())
                .mandatory(link.getIsMandatory())
                .recommended(link.getIsRecommended())
                .build();
    }
}