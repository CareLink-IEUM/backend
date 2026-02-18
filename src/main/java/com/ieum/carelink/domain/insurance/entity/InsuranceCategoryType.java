package com.ieum.carelink.domain.insurance.entity;

/**
 * 보험 카테고리 타입 (PostgreSQL enum: insurance_category_type).
 *
 * MINI    : 미니 보험
 * DISEASE : 질병
 * INJURY  : 상해/산업
 * DENTAL  : 치아
 * DRIVER  : 운전
 * LIVING  : 생활/권리
 */
public enum InsuranceCategoryType {
    MINI,
    DISEASE,
    INJURY,
    DENTAL,
    DRIVER,
    LIVING
}


