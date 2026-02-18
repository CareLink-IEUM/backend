-- =====================================================
-- 1. 기초 데이터 정리 및 초기화
-- =====================================================
TRUNCATE insurance_contract_detail, insurance_contract, product_coverage_link, 
         insurance_coverage, insurance_product, member CASCADE;

ALTER SEQUENCE insurance_coverage_coverage_id_seq RESTART WITH 1;
ALTER SEQUENCE insurance_product_product_id_seq RESTART WITH 1;
ALTER SEQUENCE product_coverage_link_link_id_seq RESTART WITH 1;
ALTER SEQUENCE member_member_id_seq RESTART WITH 1;

-------------------------------------------------------
-- Member 데이터
-------------------------------------------------------
INSERT INTO member (email, password, name, nationality, visa_type, birth_date, gender)
VALUES ('nguyen@test.com', 'encrypted_pwd', 'Nguyen Van A', 'Vietnam', 'E-7', '1990-05-20', 'MALE');

-- =====================================================
-- 2. 담보(Coverage) 마스터 데이터
-- =====================================================
INSERT INTO insurance_coverage (category, name, description) VALUES
('DISEASE', '일반암 진단비', '암 확정 진단 시 가입금액 지급'),
('DISEASE', '뇌혈관질환 진단비', '뇌혈관 질환 확정 시 지급'),
('DISEASE', '허혈성심장질환 진단비', '심장 질환 확정 시 지급'),
('DISEASE', '표적항암약물허가치료비', '표적항암제 치료 시 보상'),
('INJURY', '상해사망', '상해로 인한 사망 시 지급'),
('INJURY', '상해후유장해(80%이상)', '심각한 후유장해 발생 시 지급'),
('INJURY', '골절진단비', '골절(치아제외) 발생 시 진단비 지급'),
('INJURY', '상해수술비', '상해로 인한 수술 시 회당 지급'),
('DENTAL', '임플란트 치료비', '임플란트 시술 시 개당 지급'),
('DENTAL', '크라운 치료비', '치아 크라운 치료 시 개당 지급'),
('DENTAL', '치석제거(스케일링) 지원금', '연 1회 스케일링 비용 지원'),
('DRIVER', '교통사고처리지원금', '형사합의금 발생 시 보상'),
('DRIVER', '운전자벌금(대인)', '확정판결된 벌금액 보상'),
('DRIVER', '자동차사고 변호사선임비용', '변호사 선임 비용 실손 보상'),
('LIVING', '일상생활 배상책임', '타인에게 끼친 재산/신체 손해 배상'),
('LIVING', '화재손해(건물/가재)', '화재로 인한 우리집 실손해 보상'),
('LIVING', '여가활동중 상해수술비', '등산, 캠핑 중 사고 수술 보상');

-- =====================================================
-- 3. 보험 상품(Product) 생성 (ID 1~6)
-- =====================================================
INSERT INTO insurance_product (product_id, name, product_type, category, provider, base_price, description) VALUES 
(1, '한화 Bridge 자유 설계 종합', 'CUSTOM', 'LIVING', '한화손해보험', 1000, '모든 카테고리를 내 맘대로 조합하는 종합보험'),
(2, '한화 1코노미 질병미니', 'MINI', 'DISEASE', '한화손해보험', 0, '질병 진단비에 집중한 실속형 미니보험'),
(3, '한화 1코노미 상해미니', 'MINI', 'INJURY', '한화손해보험', 0, '일상 속 상해 사고 대비 미니보험'),
(4, '한화 1코노미 치아미니', 'MINI', 'DENTAL', '한화손해보험', 0, '꼭 필요한 치과 치료만 담은 미니보험'),
(5, '한화 1코노미 운전자미니', 'MINI', 'DRIVER', '한화손해보험', 0, '핵심 운전자 비용만 담은 가성비 보험'),
(6, '한화 1코노미 생활미니', 'MINI', 'LIVING', '한화손해보험', 0, '화재 및 배상책임 집중 보장 미니보험');

-- =====================================================
-- 4. 상품-담보 연결 (is_recommended 반영)
-- =====================================================

-------------------------------------------------------
-- ID 1: 자유 조립형 (종합)
-------------------------------------------------------
-- 필수(Mandatory)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '일반암 진단비'), 20000000, 3500, TRUE, FALSE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해사망'), 50000000, 1200, TRUE, FALSE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '임플란트 치료비'), 1000000, 4000, TRUE, FALSE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '교통사고처리지원금'), 30000000, 1500, TRUE, FALSE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '일상생활 배상책임'), 100000000, 800, TRUE, FALSE);

-- 선택(Optional) 중 "추천": 뇌혈관질환, 화재손해
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 1, coverage_id, 10000000, 2500, FALSE, TRUE FROM insurance_coverage 
WHERE name IN ('뇌혈관질환 진단비', '화재손해(건물/가재)');

-- 선택(Optional) 중 "일반"
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 1, coverage_id, 10000000, 2000, FALSE, FALSE FROM insurance_coverage 
WHERE name NOT IN ('일반암 진단비', '상해사망', '임플란트 치료비', '교통사고처리지원금', '일상생활 배상책임', '뇌혈관질환 진단비', '화재손해(건물/가재)');

-------------------------------------------------------
-- ID 2~6: MINI 시리즈
-------------------------------------------------------
-- ID 2 (질병미니): 필수 지정
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(2, (SELECT coverage_id FROM insurance_coverage WHERE name = '일반암 진단비'), 30000000, 5000, TRUE, FALSE),
(2, (SELECT coverage_id FROM insurance_coverage WHERE name = '표적항암약물허가치료비'), 50000000, 2000, TRUE, FALSE);
-- ID 2: 나머지 선택 (뇌혈관 추천)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 2, coverage_id, 5000000, 1500, FALSE, (CASE WHEN name = '뇌혈관질환 진단비' THEN TRUE ELSE FALSE END)
FROM insurance_coverage WHERE name NOT IN ('일반암 진단비', '표적항암약물허가치료비');

-- ID 3 (상해미니)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해사망'), 100000000, 1500, TRUE, FALSE),
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '골절진단비'), 300000, 500, TRUE, FALSE),
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해수술비'), 500000, 800, TRUE, FALSE);
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 3, coverage_id, 5000000, 1000, FALSE, FALSE FROM insurance_coverage WHERE name NOT IN ('상해사망', '골절진단비', '상해수술비');

-- ID 4 (치아미니)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(4, (SELECT coverage_id FROM insurance_coverage WHERE name = '임플란트 치료비'), 1500000, 7000, TRUE, FALSE);
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 4, coverage_id, 3000000, 1200, FALSE, (CASE WHEN name = '크라운 치료비' THEN TRUE ELSE FALSE END)
FROM insurance_coverage WHERE name <> '임플란트 치료비';

-- ID 5 (운전자미니)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(5, (SELECT coverage_id FROM insurance_coverage WHERE name = '교통사고처리지원금'), 50000000, 2000, TRUE, FALSE),
(5, (SELECT coverage_id FROM insurance_coverage WHERE name = '운전자벌금(대인)'), 20000000, 1000, TRUE, FALSE);
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 5, coverage_id, 4000000, 1500, FALSE, FALSE FROM insurance_coverage WHERE name NOT IN ('교통사고처리지원금', '운전자벌금(대인)');

-- ID 6 (생활미니)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended) VALUES
(6, (SELECT coverage_id FROM insurance_coverage WHERE name = '일상생활 배상책임'), 100000000, 1000, TRUE, FALSE);
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 6, coverage_id, 15000000, 2500, FALSE, (CASE WHEN name = '화재손해(건물/가재)' THEN TRUE ELSE FALSE END)
FROM insurance_coverage WHERE name <> '일상생활 배상책임';