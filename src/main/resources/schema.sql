-- [초기화] 기존 테이블 삭제
DROP TABLE IF EXISTS insurance_contract_detail CASCADE;
DROP TABLE IF EXISTS insurance_contract CASCADE;
DROP TABLE IF EXISTS insurance_coverage CASCADE;
DROP TABLE IF EXISTS insurance_product CASCADE;
DROP TABLE IF EXISTS family_member CASCADE;
DROP TABLE IF EXISTS member CASCADE;

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
INSERT INTO member (email, password, name, nationality, visa_type, birth_date, gender)
VALUES ('nguyen@test.com', 'encrypted_pwd', 'Nguyen Van A', 'Vietnam', 'E-7', '1990-05-20', 'MALE');

-- 가족 구성원
-- CREATE TABLE family_member (
--     family_id       BIGSERIAL       PRIMARY KEY,
--     member_id       BIGINT          NOT NULL,
--     name            VARCHAR(50)     NOT NULL,
--     relation        VARCHAR(20)     NOT NULL, -- SPOUSE, CHILD, PARENT
--     birth_date      DATE,
--     created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    
--     FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
-- );


-------------------------------------------------------
-- 2. Insurance Domain
-------------------------------------------------------

-- 보험 상품 마스터
CREATE TABLE insurance_product (
    product_id      BIGSERIAL       PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,       -- 상품명
    product_type    VARCHAR(20)     NOT NULL,       -- FIXED(기성품), CUSTOM(조립식)
    category        VARCHAR(30)     NOT NULL,       -- LIFE, HEALTH, DENTAL, FIRE
    description     TEXT,                           -- 상품 설명
    base_price      INTEGER         DEFAULT 0,      -- 기본 운용비
    provider        VARCHAR(50)     NOT NULL,       -- 보험사 (한화손해보험 등)
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 보험 담보/특약 (조립형)
CREATE TABLE insurance_coverage (
    coverage_id     BIGSERIAL       PRIMARY KEY,
    product_id      BIGINT          NOT NULL,
    
    category        VARCHAR(50),                    -- 의료비, 배상책임, 치과 등
    name            VARCHAR(100)    NOT NULL,       -- 담보명
    description     TEXT,
    
    amount          BIGINT          DEFAULT 0,      -- 보장 한도 (단위: 원)
    monthly_price   INTEGER         DEFAULT 0,      -- 월 보험료
    is_mandatory    BOOLEAN         DEFAULT FALSE,  -- TRUE: 필수(주계약), FALSE: 선택(특약)
    
    FOREIGN KEY (product_id) REFERENCES insurance_product(product_id) ON DELETE CASCADE
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


INSERT INTO insurance_product (name, product_type, category, description, base_price, provider)
VALUES 
('(무) 한화 더건강한 한아름종합보험', 'FIXED', 'HEALTH', '상해, 질병, 수술비까지 하나로 보장하는 한화의 대표 종합보험', 0, '한화손해보험'),
('한화 Lifeplus Bridge 조립식 보험', 'CUSTOM', 'MIXED', '치과 치료와 주택 화재 보장을 내 맘대로 조립하는 외국인 전용 보험', 1000, '한화손해보험');

INSERT INTO insurance_coverage (product_id, category, name, amount, monthly_price, is_mandatory, description)
VALUES
(1, '기본계약', '상해사망(보통약관)', 50000000, 3000, TRUE, '상해의 직접 결과로 사망 시 가입금액 지급'),
(1, '납입면제', '8대사유 납입면제', 100000, 281, FALSE, '암, 뇌졸중 등 8대 사유 발생 시 차회 보험료 면제'),
(1, '수술비', '상해종합병원수술비', 300000, 522, FALSE, '상해로 종합병원 수술 시 지급'),
(1, '수술비', '질병종합병원수술비', 300000, 2310, FALSE, '질병으로 종합병원 수술 시 지급'),
(1, '수술비', '질병 1-5종 수술비', 15500000, 28987, FALSE, '질병 수술 시 1~5종 등급에 따라 차등 지급');


INSERT INTO insurance_coverage (product_id, category, name, amount, monthly_price, is_mandatory, description)
VALUES
(2, '치과', '보존치료(크라운/레진)', 100000, 1500, FALSE, '충치 치료(레진, 크라운) 시 치아당 지급'),
(2, '치과', '보철치료(임플란트)', 500000, 3500, FALSE, '임플란트 식립 시 치아당 지급 (무제한)'),
(2, '치과', '보철치료(틀니)', 500000, 1000, FALSE, '틀니 치료 시 연간 1회 지급'),
(2, '치과', '스케일링', 10000, 100, FALSE, '치석제거(스케일링) 치료 시 지급'),
(2, '치과', '치아파절 진단비', 100000, 500, FALSE, '외부 충격으로 치아 깨짐 진단 시 지급');

INSERT INTO insurance_coverage (product_id, category, name, amount, monthly_price, is_mandatory, description)
VALUES
(2, '주거', '화재손해(건물/가재)', 200000000, 5000, TRUE, '화재로 인한 집과 가재도구의 실손해 보상 (필수)'),
(2, '주거', '화재배상책임', 2000000000, 500, FALSE, '우리집 불이 번져서 타인에게 피해를 입힌 경우 배상'),
(2, '주거', '가전제품수리비', 1000000, 3800, FALSE, '12대 가전제품 고장 시 수리비 실비 지급'),
(2, '주거', '급배수시설누출손해', 5000000, 2500, FALSE, '수도관 누수 등으로 인한 손해 보상'),
(2, '주거', '임시거주비', 250000, 250, FALSE, '화재로 거주 불가능 시 숙박비 지원');

-- [4] 시뮬레이션: 사용자가 '조립식 보험'을 가입하는 상황
-- 상황: Nguyen씨가 Bridge 보험(ID 2)에서 [화재손해(필수) + 임플란트 + 가전제품수리]를 선택

-- 1. 계약서 생성 (Header)
-- 총액 계산: 기본료(1000) + 화재(5000) + 임플란트(3500) + 가전(3800) = 13,300원
INSERT INTO insurance_contract (member_id, product_id, total_price, start_date, end_date, status)
VALUES (1, 2, 13300, '2026-03-01', '2027-03-01', 'ACTIVE');

-- 2. 상세 내역 저장 (Body)
INSERT INTO insurance_contract_detail (contract_id, coverage_id)
VALUES
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '화재손해(건물/가재)')),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '보철치료(임플란트)')),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '가전제품수리비'));

--------------------------------------------------------
-- 보험 조회용 view
--------------------------------------------------------
CREATE OR REPLACE VIEW user_current_insurance AS
SELECT 
    m.member_id,
    m.name AS member_name,
    ic.contract_id,
    ip.name AS product_name,
    ip.product_type,
    ip.category AS product_category,
    ic.total_price,
    ic.payment_cycle,
    ic.status AS contract_status,
    ic.start_date,
    ic.end_date,
    icov.coverage_id,
    icov.name AS coverage_name,
    icov.category AS coverage_category,
    icov.amount,
    icov.monthly_price,
    icov.is_mandatory
FROM member m
JOIN insurance_contract ic ON m.member_id = ic.member_id
JOIN insurance_product ip ON ic.product_id = ip.product_id
JOIN insurance_coverage icov ON ip.product_id = icov.product_id
JOIN insurance_contract_detail icd
    ON ic.contract_id = icd.contract_id 
   AND icov.coverage_id = icd.coverage_id
WHERE icov.is_mandatory = TRUE
   OR icd.detail_id IS NOT NULL;


-- 사용 예시
-- SELECT *
-- FROM user_current_insurance
-- WHERE member_id = 1
-- ORDER BY contract_id, coverage_id;