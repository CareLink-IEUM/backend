package com.ieum.carelink.domain.insurance.repository;

import com.ieum.carelink.domain.insurance.entity.InsuranceProduct;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InsuranceProductRepository extends JpaRepository<InsuranceProduct, Long> {
}