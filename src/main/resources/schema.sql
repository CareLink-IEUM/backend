DROP VIEW IF EXISTS user_current_insurance;
DROP TABLE IF EXISTS insurance_claim CASCADE;
DROP TABLE IF EXISTS medical_document CASCADE;
DROP TABLE IF EXISTS hospital_visit CASCADE;
DROP TABLE IF EXISTS emergency_event CASCADE;
DROP TABLE IF EXISTS insurance_contract_detail CASCADE;
DROP TABLE IF EXISTS insurance_contract CASCADE;
DROP TABLE IF EXISTS product_coverage_link CASCADE;
DROP TABLE IF EXISTS insurance_coverage CASCADE;
DROP TABLE IF EXISTS insurance_product CASCADE;
DROP TABLE IF EXISTS social_insurance CASCADE;
DROP TABLE IF EXISTS family_member CASCADE;
DROP TABLE IF EXISTS member CASCADE;
DROP TABLE IF EXISTS departure_service CASCADE;
DROP TABLE IF EXISTS bank_account CASCADE;
DROP TABLE IF EXISTS currency_exchange CASCADE;
DROP TABLE IF EXISTS insurance_transfer CASCADE;
DROP TYPE IF EXISTS insurance_category_type CASCADE;

-------------------------------------------------------
-- 1. Member Domain
-------------------------------------------------------
CREATE TABLE member (
    member_id       BIGSERIAL       PRIMARY KEY,
    email           VARCHAR(100)    NOT NULL UNIQUE,
    password        VARCHAR(255)    NOT NULL,
    name            VARCHAR(50)     NOT NULL,
    nationality     VARCHAR(50)     NOT NULL, -- ex: Vietnam, USA
    visa_type       VARCHAR(20),              -- ex: E-7, D-2
    birth_date      DATE,
    gender          VARCHAR(10),              -- MALE, FEMALE
    phone           VARCHAR(20),
    role            VARCHAR(20)     DEFAULT 'USER',
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
-- 가족 구성원
CREATE TABLE family_member (
    family_id       BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    name            VARCHAR(50) NOT NULL,
    relation        VARCHAR(20) NOT NULL, -- SPOUSE, CHILD, PARENT
    birth_date      DATE,
    nationality     VARCHAR(50),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

-------------------------------------------------------
-- 2. Insurance Domain
-------------------------------------------------------
-- 카테고리 고정
CREATE TYPE insurance_category_type AS ENUM (
    'MINI',     -- 미니
    'DISEASE',  -- 질병
    'INJURY',   -- 상해/산업
    'DENTAL',   -- 치아
    'DRIVER',   -- 운전
    'LIVING'    -- 생활/권리
);

-- 보험 상품 껍데기
CREATE TABLE insurance_product (
    product_id      BIGSERIAL       PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,       -- 상품명 (예: 암 안심 케어, 라이더 안심 케어)
    product_type    VARCHAR(20)     NOT NULL,       -- MINI(미니), CUSTOM(조립식), FIXED(기성품)
    category        insurance_category_type NOT NULL,       -- HEALTH, DENTAL, DRIVER 등
    description     TEXT,
    base_price      INTEGER         DEFAULT 0,
    provider        VARCHAR(50)     NOT NULL,       -- 한화손해보험 등
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
-- 보험 담보/특약 마스터
CREATE TABLE insurance_coverage (
    coverage_id     BIGSERIAL       PRIMARY KEY,
    category        VARCHAR(50),                    -- 상해, 치과, 주거 등
    name            VARCHAR(100)    NOT NULL,       -- 담보명
    description     TEXT,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 상품-담보 연결
CREATE TABLE product_coverage_link (
    link_id         BIGSERIAL       PRIMARY KEY,
    product_id      BIGINT          NOT NULL,
    coverage_id     BIGINT          NOT NULL,
    amount          BIGINT          DEFAULT 0,      -- 보장 한도
    monthly_price   INTEGER         DEFAULT 0,      -- 월 보험료
    is_mandatory    BOOLEAN         DEFAULT FALSE,  -- 필수 여부
    
    FOREIGN KEY (product_id) REFERENCES insurance_product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (coverage_id) REFERENCES insurance_coverage(coverage_id) ON DELETE CASCADE
);

-- 4대 보험
CREATE TABLE social_insurance (
    social_id       BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    type            VARCHAR(30), -- 국민연금, 건강보험 등
    provider        VARCHAR(100),
    coverage_status VARCHAR(50),
    last_checked_at TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

-------------------------------------------------------
-- 3. Contract Domain
-------------------------------------------------------

-- 보험 계약서
CREATE TABLE insurance_contract (
    contract_id     BIGSERIAL       PRIMARY KEY,
    member_id       BIGINT          NOT NULL,
    product_id      BIGINT          NOT NULL,
    payment_cycle   VARCHAR(20)     DEFAULT 'MONTHLY', -- MONTHLY, YEARLY, LUMP_SUM
    total_price     INTEGER         NOT NULL,       -- 최종 월 납입액 합계
    status          VARCHAR(20)     DEFAULT 'ACTIVE', -- ACTIVE, EXPIRED, CANCELLED
    
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES insurance_product(product_id)
);

-- 계약 상세 내역
CREATE TABLE insurance_contract_detail (
    detail_id       BIGSERIAL       PRIMARY KEY,
    contract_id     BIGINT          NOT NULL,
    coverage_id     BIGINT          NOT NULL,
    
    FOREIGN KEY (contract_id) REFERENCES insurance_contract(contract_id) ON DELETE CASCADE,
    FOREIGN KEY (coverage_id) REFERENCES insurance_coverage(coverage_id)
);


-------------------------------------------------------
-- 4. Hospital Domain
-------------------------------------------------------
-- 응급신고 기록
CREATE TABLE emergency_event (
    emergency_id    BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    description     TEXT,
    severity_level  VARCHAR(20), -- LOW, MEDIUM, HIGH
    consent_given   BOOLEAN DEFAULT FALSE,
    reported_119    BOOLEAN DEFAULT FALSE,
    location_lat    NUMERIC(10,7),
    location_lng    NUMERIC(10,7),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);
-- 병원방문 기록
CREATE TABLE hospital_visit (
    visit_id        BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    hospital_name   VARCHAR(255),
    department      VARCHAR(100), -- 내과, 외과 등
    visit_date      DATE,
    symptoms        TEXT,
    diagnosis       TEXT,
    visit_type VARCHAR(20) DEFAULT 'NORMAL',
    emergency_id    BIGINT,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (emergency_id) REFERENCES emergency_event(emergency_id)
);

-- 진단서, 영수증
CREATE TABLE medical_document (
    document_id     BIGSERIAL PRIMARY KEY,
    visit_id        BIGINT NOT NULL,
    document_type   VARCHAR(50), -- RECEIPT, DIAGNOSIS
    file_url        TEXT,
    ocr_text        TEXT,
    verified        BOOLEAN DEFAULT FALSE,
    uploaded_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (visit_id) REFERENCES hospital_visit(visit_id) ON DELETE CASCADE
);

-- 보험금 청구
CREATE TABLE insurance_claim (
    claim_id        BIGSERIAL PRIMARY KEY,
    contract_id     BIGINT NOT NULL,
    visit_id        BIGINT NOT NULL,
    claim_amount    BIGINT,
    status          VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    auto_submitted  BOOLEAN DEFAULT FALSE,
    submitted_at    TIMESTAMP,
    processed_at    TIMESTAMP,

    FOREIGN KEY (contract_id) REFERENCES insurance_contract(contract_id),
    FOREIGN KEY (visit_id) REFERENCES hospital_visit(visit_id)
);

-------------------------------------------------------
-- 5. Department Domain
-------------------------------------------------------
-- 귀국 일정
CREATE TABLE departure_service (
    departure_id    BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    planned_date    DATE,
    status          VARCHAR(30), -- PLANNED, PROCESSING, COMPLETED

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);
-- 계좌정리
CREATE TABLE bank_account (
    account_id      BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    bank_name       VARCHAR(100),
    account_masked  VARCHAR(50),
    is_closed       BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

-- 환전
CREATE TABLE currency_exchange (
    exchange_id     BIGSERIAL PRIMARY KEY,
    member_id       BIGINT NOT NULL,
    from_currency   VARCHAR(10),
    to_currency     VARCHAR(10),
    amount          NUMERIC(14,2),
    exchange_rate   NUMERIC(12,6),
    processed_at    TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

-- 보험 해지, 이전
CREATE TABLE insurance_transfer (
    transfer_id     BIGSERIAL PRIMARY KEY,
    contract_id     BIGINT NOT NULL,
    action_type     VARCHAR(20), -- CANCEL, TRANSFER, REJOIN
    target_country  VARCHAR(50),
    processed_at    TIMESTAMP,

    FOREIGN KEY (contract_id) REFERENCES insurance_contract(contract_id)
);

INSERT INTO member (email, password, name, nationality, visa_type, birth_date, gender)
VALUES ('nguyen@test.com', 'encrypted_pwd', 'Nguyen Van A', 'Vietnam', 'E-7', '1990-05-20', 'MALE');

INSERT INTO insurance_product (name, product_type, category, provider, base_price) VALUES 
('자동차보험', 'FIXED', 'DRIVER', '한화손해보험', 0),
('한화 Bridge 조립식 종합', 'CUSTOM', 'LIVING', '한화손해보험', 1000);

INSERT INTO insurance_coverage (category, name, description) VALUES
('상해', '상해사망(보통약관)', '사망 시 지급'),
('치과', '임플란트 치료비', '임플란트 시술 시 지급'),
('주거', '화재손해(건물/가재)', '화재로 인한 집과 가재도구의 실손해 보상');

INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
VALUES (2, (SELECT coverage_id FROM insurance_coverage WHERE name = '화재손해(건물/가재)'), 200000000, 5000, TRUE);

INSERT INTO insurance_contract (member_id, product_id, total_price, start_date, end_date)
VALUES (1, 2, 6000, '2026-03-01', '2027-03-01'); -- 기본료 1000 + 화재 5000 = 6000

INSERT INTO insurance_contract_detail (contract_id, coverage_id)
VALUES (1, (SELECT coverage_id FROM insurance_coverage WHERE name = '화재손해(건물/가재)'));-------------------------------------------------------

-- 보험 조회용 view
--------------------------------------------------------
CREATE OR REPLACE VIEW user_current_insurance AS
SELECT 
    m.member_id,
    ic.contract_id,
    ip.name AS product_name,
    icov.name AS coverage_name,
    pcl.amount AS coverage_amount,
    pcl.monthly_price,
    pcl.is_mandatory
FROM insurance_contract ic
JOIN member m ON ic.member_id = m.member_id
JOIN insurance_product ip ON ic.product_id = ip.product_id
JOIN insurance_contract_detail icd ON ic.contract_id = icd.contract_id
JOIN insurance_coverage icov ON icd.coverage_id = icov.coverage_id
JOIN product_coverage_link pcl 
    ON ip.product_id = pcl.product_id 
    AND icov.coverage_id = pcl.coverage_id;


-- 사용 예시
-- SELECT *
-- FROM user_current_insurance
-- WHERE member_id = 1;