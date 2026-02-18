package com.ieum.carelink.domain.member.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "social_insurance")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SocialInsurance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "social_id")
    private Long socialId;

    @Column(name = "member_id", nullable = false)
    private Long memberId;

    @Column(name = "type")
    private String type;

    @Column(name = "provider")
    private String provider;

    @Column(name = "coverage_status")
    private String coverageStatus;

    @Column(name = "last_checked_at")
    private LocalDateTime lastCheckedAt;
}