-- =====================================================
-- 1. 기초 데이터 정리 (순서 주의: 자식 테이블부터)
-- =====================================================
-- schema.sql에서 생성된 초기 데이터를 지우고 새로 구성합니다.
TRUNCATE insurance_contract_detail, insurance_contract, product_coverage_link, 
         insurance_coverage, insurance_product CASCADE;
-- SERIAL 값 초기화
ALTER SEQUENCE insurance_coverage_coverage_id_seq RESTART WITH 1;
ALTER SEQUENCE insurance_product_product_id_seq RESTART WITH 1;
ALTER SEQUENCE product_coverage_link_link_id_seq RESTART WITH 1;

-- =====================================================
-- 2. 담보(Coverage) 마스터 데이터
-- =====================================================
INSERT INTO insurance_coverage (category, name, description) VALUES
-- DISEASE
('DISEASE', '일반암 진단비', '암 확정 진단 시 가입금액 지급'),
('DISEASE', '뇌혈관질환 진단비', '뇌혈관 질환 확정 시 지급'),
('DISEASE', '허혈성심장질환 진단비', '심장 질환 확정 시 지급'),
('DISEASE', '표적항암약물허가치료비', '표적항암제 치료 시 보상'),
-- INJURY
('INJURY', '상해사망', '상해로 인한 사망 시 지급'),
('INJURY', '상해후유장해(80%이상)', '심각한 후유장해 발생 시 지급'),
('INJURY', '골절진단비', '골절(치아제외) 발생 시 진단비 지급'),
('INJURY', '상해수술비', '상해로 인한 수술 시 회당 지급'),
-- DENTAL
('DENTAL', '임플란트 치료비', '임플란트 시술 시 개당 지급'),
('DENTAL', '크라운 치료비', '치아 크라운 치료 시 개당 지급'),
('DENTAL', '치석제거(스케일링) 지원금', '연 1회 스케일링 비용 지원'),
-- DRIVER
('DRIVER', '교통사고처리지원금', '형사합의금 발생 시 보상'),
('DRIVER', '운전자벌금(대인)', '확정판결된 벌금액 보상'),
('DRIVER', '자동차사고 변호사선임비용', '변호사 선임 비용 실손 보상'),
-- LIVING
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
-- 4. 상품-담보 연결 (product_coverage_link)
-- =====================================================

-- [공통 룰] 
-- 1. 각 상품별 '필수(Mandatory)' 담보는 직접 지정
-- 2. 각 상품별 '선택(Optional)' 담보는 본인 필수 담보를 제외한 "전체 마스터"에서 연결

-------------------------------------------------------
-- ID 1: 자유 조립형 (종합)
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '일반암 진단비'), 20000000, 3500, TRUE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해사망'), 50000000, 1200, TRUE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '임플란트 치료비'), 1000000, 4000, TRUE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '교통사고처리지원금'), 30000000, 1500, TRUE),
(1, (SELECT coverage_id FROM insurance_coverage WHERE name = '일상생활 배상책임'), 100000000, 800, TRUE);

-- 선택: 위 5개 필수 담보를 제외한 모든 담보 연결
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 1, coverage_id, 10000000, 2000, FALSE FROM insurance_coverage 
WHERE name NOT IN ('일반암 진단비', '상해사망', '임플란트 치료비', '교통사고처리지원금', '일상생활 배상책임');


-------------------------------------------------------
-- ID 2: DISEASE MINI
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(2, (SELECT coverage_id FROM insurance_coverage WHERE name = '일반암 진단비'), 30000000, 5000, TRUE),
(2, (SELECT coverage_id FROM insurance_coverage WHERE name = '표적항암약물허가치료비'), 50000000, 2000, TRUE);

-- 선택: 본인 필수 담보를 제외한 모든 담보 연결 (타 카테고리 포함)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 2, coverage_id, 5000000, 1500, FALSE FROM insurance_coverage 
WHERE name NOT IN ('일반암 진단비', '표적항암약물허가치료비');


-------------------------------------------------------
-- ID 3: INJURY MINI
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해사망'), 100000000, 1500, TRUE),
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '골절진단비'), 300000, 500, TRUE),
(3, (SELECT coverage_id FROM insurance_coverage WHERE name = '상해수술비'), 500000, 800, TRUE);

-- 선택: 본인 필수 담보를 제외한 모든 담보 연결
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 3, coverage_id, 5000000, 1000, FALSE FROM insurance_coverage 
WHERE name NOT IN ('상해사망', '골절진단비', '상해수술비');


-------------------------------------------------------
-- ID 4: DENTAL MINI
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(4, (SELECT coverage_id FROM insurance_coverage WHERE name = '임플란트 치료비'), 1500000, 7000, TRUE);

-- 선택: 본인 필수 담보를 제외한 모든 담보 연결
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 4, coverage_id, 3000000, 1200, FALSE FROM insurance_coverage 
WHERE name <> '임플란트 치료비';


-------------------------------------------------------
-- ID 5: DRIVER MINI
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(5, (SELECT coverage_id FROM insurance_coverage WHERE name = '교통사고처리지원금'), 50000000, 2000, TRUE),
(5, (SELECT coverage_id FROM insurance_coverage WHERE name = '운전자벌금(대인)'), 20000000, 1000, TRUE);

-- 선택: 본인 필수 담보를 제외한 모든 담보 연결
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 5, coverage_id, 4000000, 1500, FALSE FROM insurance_coverage 
WHERE name NOT IN ('교통사고처리지원금', '운전자벌금(대인)');


-------------------------------------------------------
-- ID 6: LIVING MINI
-------------------------------------------------------
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory) VALUES
(6, (SELECT coverage_id FROM insurance_coverage WHERE name = '일상생활 배상책임'), 100000000, 1000, TRUE);

-- 선택: 본인 필수 담보를 제외한 모든 담보 연결
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory)
SELECT 6, coverage_id, 15000000, 2500, FALSE FROM insurance_coverage 
WHERE name <> '일상생활 배상책임';