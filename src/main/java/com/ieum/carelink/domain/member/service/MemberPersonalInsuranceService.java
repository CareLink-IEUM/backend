package com.ieum.carelink.domain.member.service;

import com.ieum.carelink.domain.insurance.entity.ContractStatus;
import com.ieum.carelink.domain.insurance.entity.InsuranceContract;
import com.ieum.carelink.domain.insurance.entity.InsuranceContractDetail;
import com.ieum.carelink.domain.insurance.entity.ProductCoverageLink;
import com.ieum.carelink.domain.insurance.repository.InsuranceContractRepository;
import com.ieum.carelink.domain.member.dto.CoverageDto;
import com.ieum.carelink.domain.member.dto.PersonalInsuranceContractDto;
import com.ieum.carelink.domain.member.dto.ProductSummaryDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MemberPersonalInsuranceService {

    private final InsuranceContractRepository insuranceContractRepository;

    /**
     * 회원의 개인 보험(계약) 목록 조회
     *
     * @param memberId    회원 ID
     * @param statusParam ACTIVE, EXPIRED, CANCELLED, ALL
     */
    @Transactional(readOnly = true)
    public List<PersonalInsuranceContractDto> getPersonalInsurances(Long memberId, String statusParam) {
        List<InsuranceContract> contracts;

        if (statusParam == null || statusParam.equalsIgnoreCase("ALL")) {
            contracts = insuranceContractRepository.findByMemberId(memberId);
        } else {
            ContractStatus status = ContractStatus.valueOf(statusParam.toUpperCase());
            contracts = insuranceContractRepository.findByMemberIdAndStatus(memberId, status);
        }

        return contracts.stream()
                .map(this::toDto)
                .toList();
    }

    private PersonalInsuranceContractDto toDto(InsuranceContract contract) {
        // 상품 요약
        ProductSummaryDto productSummary = ProductSummaryDto.from(contract.getProduct());

        // 선택한 담보
        List<InsuranceContractDetail> details = contract.getDetails();
        Set<Long> selectedCoverageIds = details.stream()
                .map(detail -> detail.getCoverage().getId())
                .collect(Collectors.toSet());

        List<CoverageDto> coverages = contract.getProduct().getCoverages().stream()
                .filter(link -> selectedCoverageIds.contains(link.getCoverage().getId()))
                .map(CoverageDto::from)
                .toList();

        return PersonalInsuranceContractDto.of(contract, productSummary, coverages);
    }
}