package com.ieum.carelink.domain.insurance.service;

import com.ieum.carelink.domain.insurance.dto.InsuranceProductCoverageResponse;
import com.ieum.carelink.domain.insurance.entity.InsuranceProduct;
import com.ieum.carelink.domain.insurance.entity.ProductCoverageLink;
import com.ieum.carelink.domain.insurance.repository.InsuranceProductRepository;
import com.ieum.carelink.domain.insurance.repository.ProductCoverageLinkRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/** 
 * 상품 ID -> 해당 상품의 담보 리스트 -> DTO 변환
 */
@Service
@RequiredArgsConstructor
public class InsuranceQueryService {

    private final InsuranceProductRepository insuranceProductRepository;
    private final ProductCoverageLinkRepository productCoverageLinkRepository;

    @Transactional(readOnly = true)
    public InsuranceProductCoverageResponse getProductCoverages(Long productId) {
        InsuranceProduct product = insuranceProductRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 상품입니다. productId=" + productId));
        List<ProductCoverageLink> links = productCoverageLinkRepository.findByProduct_Id(productId);
        List<InsuranceProductCoverageResponse.CoverageDetailDto> coverageDtos = links.stream()
                .map(link -> InsuranceProductCoverageResponse.CoverageDetailDto.builder()
                        .coverageId(link.getCoverage().getId())
                        .linkId(link.getId())
                        .name(link.getCoverage().getName())
                        .category(link.getCoverage().getCategory())
                        .amount(link.getAmount())
                        .price(link.getMonthlyPrice())
                        .mandatory(Boolean.TRUE.equals(link.getIsMandatory()))
                        .build())
                .collect(Collectors.toList());

        return InsuranceProductCoverageResponse.builder()
                .productId(product.getId())
                .productName(product.getName())
                .productType(product.getProductType().name())
                .coverages(coverageDtos)
                .build();
    }
}