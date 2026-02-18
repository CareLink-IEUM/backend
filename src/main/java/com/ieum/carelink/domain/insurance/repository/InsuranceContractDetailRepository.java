package com.ieum.carelink.domain.insurance.repository;

import com.ieum.carelink.domain.insurance.entity.InsuranceContractDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InsuranceContractDetailRepository extends JpaRepository<InsuranceContractDetail, Long> {
}