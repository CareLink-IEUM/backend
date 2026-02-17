-- DROP TABLE IF EXISTS member_insurance CASCADE;
-- DROP TABLE IF EXISTS insurance_component CASCADE;
-- DROP TABLE IF EXISTS insurance_product CASCADE;
-- DROP TABLE IF EXISTS family_member CASCADE;
-- DROP TABLE IF EXISTS member CASCADE;

-------------------------------------------------------
-- 1. Member Domain
-------------------------------------------------------
CREATE TABLE member (
    member_id       BIGSERIAL       PRIMARY KEY,           -- Java Long 매핑
    email           VARCHAR(100)    NOT NULL UNIQUE,       -- 로그인 ID 역할
    password        VARCHAR(255)    NOT NULL,              -- 암호화된 비번
    name            VARCHAR(50)     NOT NULL,              -- 실명
    nationality     VARCHAR(50)     NOT NULL,              -- 국적 (예: Vietnam, USA)
    visa_type       VARCHAR(20),                           -- 비자 (예: E-7, D-2, F-5)
    birth_date      DATE,                                  -- 보험 나이 계산용
    gender          VARCHAR(10),                           -- MALE, FEMALE
    phone           VARCHAR(20),   
    role            VARCHAR(20)     DEFAULT 'USER',
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 가족 구성원 테이블 (일단 이정도)
-- CREATE TABLE family_member (
--     family_id       BIGSERIAL       PRIMARY KEY,
--     member_id       BIGINT          NOT NULL,              -- 누구의 가족인가 (FK)
--     name            VARCHAR(50)     NOT NULL,
--     relation        VARCHAR(20)     NOT NULL,              -- SPOUSE(배우자), CHILD(자녀), PARENT(부모)
    
--     FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
-- );

-------------------------------------------------------
-- 2. Insurance Domain (상품 및 조립식 부품)
-------------------------------------------------------

-- 보험 상품 마스터
CREATE TABLE insurance_product (
    product_id      BIGSERIAL       PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,              -- 상품명 (예: Global Safe Life)
    category        VARCHAR(30)     NOT NULL,              -- LIFE(생명), HEALTH(건강)
    description     TEXT,                                  -- 상품 설명
    base_price      INTEGER         DEFAULT 0,             -- 기본료
    is_customizable BOOLEAN         DEFAULT FALSE          -- 조립 가능 여부
);


-- 보험 조립 부품 (핵심 기능: 특약/옵션)
-- CREATE TABLE insurance_component (
--     component_id    BIGSERIAL       PRIMARY KEY,
--     product_id      BIGINT          NOT NULL,              -- 어느 상품의 부품인가 (FK)
--     name            VARCHAR(100)    NOT NULL,              -- 부품명 (예: 암 진단비 1천만원)
--     type            VARCHAR(20)     DEFAULT 'OPTION',      -- CORE(필수), OPTION(선택)
--     coverage_amount INTEGER         NOT NULL,              -- 보장 금액 (단위: 원)
--     monthly_premium INTEGER         NOT NULL,              -- 이 부품의 월 가격
--     description     TEXT,                                  -- 부품 상세 설명
    
--     FOREIGN KEY (product_id) REFERENCES insurance_product(product_id) ON DELETE CASCADE
-- );

-------------------------------------------------------
-- 3. Contract
-------------------------------------------------------

-- 회원 보험 가입 내역
CREATE TABLE member_insurance (
    contract_id     BIGSERIAL       PRIMARY KEY,
    member_id       BIGINT          NOT NULL,              -- 가입자 (FK)
    family_id       BIGINT,                                -- (선택) 가족을 위한 보험일 경우 FK, 본인이면 NULL
    product_id      BIGINT          NOT NULL,              -- 가입 상품 (FK)
    
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    total_premium   INTEGER         NOT NULL,              -- 최종 월 납입액
    status          VARCHAR(20)     DEFAULT 'ACTIVE',      -- ACTIVE, EXPIRED, CANCELLED
    
    components_snapshot JSONB,                             
    
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (family_id) REFERENCES family_member(family_id) ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES insurance_product(product_id)
);