package com.ieum.carelink.domain.insurance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 상품-담보 연결 엔티티.
 * product_coverage_link
 */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "product_coverage_link")
public class ProductCoverageLink {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "link_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private InsuranceProduct product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coverage_id", nullable = false)
    private InsuranceCoverage coverage;

    @Column(name = "amount")
    private Long amount;

    @Column(name = "monthly_price")
    private Integer monthlyPrice;

    @Column(name = "is_mandatory")
    private Boolean isMandatory;
}