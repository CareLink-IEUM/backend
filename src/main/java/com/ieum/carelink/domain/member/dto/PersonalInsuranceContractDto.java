package com.ieum.carelink.domain.member.dto;

import com.ieum.carelink.domain.insurance.entity.InsuranceContract;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Builder
public class PersonalInsuranceContractDto {

    private Long contractId;
    private String status;
    private String paymentCycle;
    private Integer totalPrice;
    private LocalDate startDate;
    private LocalDate endDate;

    private ProductSummaryDto product;
    private List<CoverageDto> coverages;

    public static PersonalInsuranceContractDto of(InsuranceContract contract,
                                                  ProductSummaryDto productSummary,
                                                  List<CoverageDto> coverages) {
        return PersonalInsuranceContractDto.builder()
                .contractId(contract.getId())
                .status(contract.getStatus() != null ? contract.getStatus().name() : null)
                .paymentCycle(contract.getPaymentCycle() != null ? contract.getPaymentCycle().name() : null)
                .totalPrice(contract.getTotalPrice())
                .startDate(contract.getStartDate())
                .endDate(contract.getEndDate())
                .product(productSummary)
                .coverages(coverages)
                .build();
    }
}