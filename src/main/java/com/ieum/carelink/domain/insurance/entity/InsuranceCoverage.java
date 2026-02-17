package com.ieum.carelink.domain.insurance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 보험 담보/특약 마스터 엔티티
 * insurance_coverage
 */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "insurance_coverage")
public class InsuranceCoverage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "coverage_id")
    private Long id;

    @Column(name = "category", length = 50)
    private String category;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "coverage", fetch = FetchType.LAZY)
    private List<ProductCoverageLink> productLinks = new ArrayList<>();

    @OneToMany(mappedBy = "coverage", fetch = FetchType.LAZY)
    private List<InsuranceContractDetail> contractDetails = new ArrayList<>();
}


