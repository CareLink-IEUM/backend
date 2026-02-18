package com.ieum.carelink.domain.member.dto;

import com.ieum.carelink.domain.insurance.entity.InsuranceProduct;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductSummaryDto {

    private Long productId;
    private String name;
    private String category;
    private String productType;
    private String provider;
    private String description;

    public static ProductSummaryDto from(InsuranceProduct product) {
        return ProductSummaryDto.builder()
                .productId(product.getId())
                .name(product.getName())
                .category(product.getCategory() != null ? product.getCategory().name() : null)
                .productType(product.getProductType() != null ? product.getProductType().name() : null)
                .provider(product.getProvider())
                .description(product.getDescription())
                .build();
    }
}