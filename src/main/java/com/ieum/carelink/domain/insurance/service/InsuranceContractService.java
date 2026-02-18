package com.ieum.carelink.domain.insurance.service;

import com.ieum.carelink.domain.insurance.dto.InsuranceContractRequest;
import com.ieum.carelink.domain.insurance.dto.InsuranceContractResponse;
import com.ieum.carelink.domain.insurance.entity.*;
import com.ieum.carelink.domain.insurance.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InsuranceContractService {

    private final InsuranceProductRepository insuranceProductRepository;
    private final ProductCoverageLinkRepository productCoverageLinkRepository;
    private final InsuranceContractRepository insuranceContractRepository;
    private final InsuranceContractDetailRepository insuranceContractDetailRepository;

    /**
     * 보험 가입 처리 및 검증
     * - CUSTOM: 필수 담보 1개 이상 선택
     * - MINI  : 필수 담보 모두 선택
     */
    @Transactional
    public InsuranceContractResponse createContract(InsuranceContractRequest request) {
        InsuranceProduct product = insuranceProductRepository.findById(request.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 상품입니다. productId=" + request.getProductId()));

        List<ProductCoverageLink> allLinks = productCoverageLinkRepository.findByProduct_Id(product.getId());

        if (allLinks.isEmpty()) {
            throw new IllegalArgumentException("해당 상품에 연결된 담보가 없습니다. productId=" + product.getId());
        }

        Set<Long> requestedCoverageIds = new HashSet<>(request.getCoverageIds());

        List<ProductCoverageLink> selectedLinks = allLinks.stream()
                .filter(link -> requestedCoverageIds.contains(link.getCoverage().getId()))
                .toList();

        if (selectedLinks.isEmpty()) {
            throw new IllegalArgumentException("선택한 담보가 상품에 존재하지 않습니다.");
        }

        List<ProductCoverageLink> mandatoryLinks = allLinks.stream()
                .filter(link -> Boolean.TRUE.equals(link.getIsMandatory()))
                .toList();

        if (product.getProductType() == ProductType.CUSTOM) {
            // 조립형: 필수 중 1개 이상 포함
            boolean hasAtLeastOneMandatory = selectedLinks.stream()
                    .anyMatch(link -> Boolean.TRUE.equals(link.getIsMandatory()));
            if (!hasAtLeastOneMandatory) {
                throw new IllegalArgumentException("조립형 보험은 필수(Core) 담보를 최소 1개 이상 포함해야 합니다.");
            }
        } else if (product.getProductType() == ProductType.MINI) {
            // 미니: 필수 모두 포함
            Set<Long> selectedCoverageIds = selectedLinks.stream()
                    .map(link -> link.getCoverage().getId())
                    .collect(Collectors.toSet());

            boolean allMandatoryIncluded = mandatoryLinks.stream()
                    .allMatch(link -> selectedCoverageIds.contains(link.getCoverage().getId()));

            if (!allMandatoryIncluded) {
                throw new IllegalArgumentException("미니 보험은 필수(Core) 담보를 모두 선택해야 합니다.");
            }
        }

        // 5) 총 보험료 계산: base_price + 선택한 담보의 monthly_price 합
        int totalPriceFromLinks = selectedLinks.stream()
                .map(ProductCoverageLink::getMonthlyPrice)
                .filter(price -> price != null)
                .mapToInt(Integer::intValue)
                .sum();

        int basePrice = product.getBasePrice() != null ? product.getBasePrice() : 0;
        int totalPrice = basePrice + totalPriceFromLinks;

        // 6) 계약 기간 기본값 설정 (요청 값 없으면 1년)
        LocalDate startDate = request.getStartDate() != null ? request.getStartDate() : LocalDate.now();
        LocalDate endDate = request.getEndDate() != null ? request.getEndDate() : startDate.plusYears(1);

        // 7) InsuranceContract 엔티티 생성/저장
        PaymentCycle paymentCycle = request.getPaymentCycle() != null
                ? PaymentCycle.valueOf(request.getPaymentCycle())
                : PaymentCycle.MONTHLY;

        InsuranceContract contract = InsuranceContract.create(
                request.getMemberId(),
                product,
                paymentCycle,
                totalPrice,
                ContractStatus.ACTIVE,
                startDate,
                endDate
        );
        InsuranceContract savedContract = insuranceContractRepository.save(contract);

        // 8) 계약 상세 저장
        List<InsuranceContractDetail> details = selectedLinks.stream()
                .map(link -> InsuranceContractDetail.create(savedContract, link.getCoverage()))
                .toList();
        insuranceContractDetailRepository.saveAll(details);

        // 9) 응답 DTO 구성
        List<Long> finalCoverageIds = details.stream()
                .map(detail -> detail.getCoverage().getId())
                .toList();

        return InsuranceContractResponse.builder()
                .contractId(savedContract.getId())
                .memberId(savedContract.getMemberId())
                .productId(product.getId())
                .productName(product.getName())
                .productType(product.getProductType().name())
                .totalPrice(savedContract.getTotalPrice())
                .status(savedContract.getStatus() != null ? savedContract.getStatus().name() : null)
                .paymentCycle(savedContract.getPaymentCycle() != null ? savedContract.getPaymentCycle().name() : null)
                .startDate(savedContract.getStartDate())
                .endDate(savedContract.getEndDate())
                .coverageIds(finalCoverageIds)
                .build();
    }

}


