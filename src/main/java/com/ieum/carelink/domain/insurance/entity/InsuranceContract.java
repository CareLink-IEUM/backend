package com.ieum.carelink.domain.insurance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 보험 계약서
 * insurance_contract 테이블
 */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "insurance_contract")
public class InsuranceContract {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "contract_id")
    private Long id;

    /**
     * 가입 회원 ID
     *  TODO 멤버 entity랑 연결해야함!
     */
    @Column(name = "member_id", nullable = false)
    private Long memberId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private InsuranceProduct product;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_cycle", length = 20)
    private PaymentCycle paymentCycle;

    @Column(name = "total_price", nullable = false)
    private Integer totalPrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 20)
    private ContractStatus status;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "contract", fetch = FetchType.LAZY)
    private List<InsuranceContractDetail> details = new ArrayList<>();

    // 생성용 팩토리 메서드
    public static InsuranceContract create(Long memberId,
                                           InsuranceProduct product,
                                           PaymentCycle paymentCycle,
                                           Integer totalPrice,
                                           ContractStatus status,
                                           LocalDate startDate,
                                           LocalDate endDate) {
        InsuranceContract contract = new InsuranceContract();
        contract.memberId = memberId;
        contract.product = product;
        contract.paymentCycle = paymentCycle;
        contract.totalPrice = totalPrice;
        contract.status = status;
        contract.startDate = startDate;
        contract.endDate = endDate;
        contract.createdAt = LocalDateTime.now();
        return contract;
    }
}


