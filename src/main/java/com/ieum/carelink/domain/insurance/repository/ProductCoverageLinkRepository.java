package com.ieum.carelink.domain.insurance.repository;

import com.ieum.carelink.domain.insurance.entity.ProductCoverageLink;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductCoverageLinkRepository extends JpaRepository<ProductCoverageLink, Long> {
    List<ProductCoverageLink> findByProduct_Id(Long productId);
}