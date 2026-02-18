package com.ieum.carelink.domain.insurance.repository;

import com.ieum.carelink.domain.insurance.entity.ContractStatus;
import com.ieum.carelink.domain.insurance.entity.InsuranceContract;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InsuranceContractRepository extends JpaRepository<InsuranceContract, Long> {

    List<InsuranceContract> findByMemberId(Long memberId);

    List<InsuranceContract> findByMemberIdAndStatus(Long memberId, ContractStatus status);
}