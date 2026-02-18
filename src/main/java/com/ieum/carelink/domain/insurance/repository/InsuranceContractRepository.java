package com.ieum.carelink.domain.insurance.repository;

import com.ieum.carelink.domain.insurance.entity.InsuranceContract;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InsuranceContractRepository extends JpaRepository<InsuranceContract, Long> {
}