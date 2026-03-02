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

-- [A] 기존 샘플 담보 (ID 1 ~ 11 그대로 유지)
INSERT INTO insurance_coverage (coverage_id, category, name, description) VALUES
(1, 'DISEASE', '일반암 진단비', '암 확정 진단 시 가입금액 지급'),
(2, 'DISEASE', '뇌혈관질환 진단비', '뇌혈관 질환 확정 시 지급'),
(3, 'DISEASE', '허혈성심장질환 진단비', '심장 질환 확정 시 지급'),
(4, 'DISEASE', '표적항암약물허가치료비', '표적항암제 치료 시 보상'),
(5, 'DENTAL', '임플란트 치료비', '임플란트 시술 시 개당 지급'),
(6, 'DENTAL', '크라운 치료비', '치아 크라운 치료 시 개당 지급'),
(7, 'DRIVER', '교통사고처리지원금', '형사합의금 발생 시 보상'),
(8, 'DRIVER', '운전자벌금(대인)', '확정판결된 벌금액 보상'),
(9, 'LIVING', '일상생활 배상책임', '타인에게 끼친 재산/신체 손해 배상'),
(10, 'LIVING', '화재손해(건물/가재)', '화재로 인한 우리집 실손해 보상'),
(11, 'LIVING', '여가활동중 상해수술비', '등산, 캠핑 중 사고 수술 보상');

-- [B] JSON 기반 실제 약관 데이터 (ID 100 ~ 120으로 명시적 입력)
INSERT INTO insurance_coverage (coverage_id, name, category, description) VALUES
(100, '무배당 한화 BigPlus 재산종합보험 보통약관', 'COMMON_TERMS', '이 보험의 가장 기본이 되는 필수 가입 항목'),
(101, '1. 상해관련 특별약관', 'INJURY', '상해 사고 종합 보장'),
(102, '1-1. 화재상해사망 특별약관', 'INJURY', '화재 사고로 인한 사망 시 지급'),
(103, '1-2. 상해사망 특별약관', 'INJURY', '일반 상해 사망 시 가입금액 지급'),
(104, '1-3. 업무중상해사망(출퇴근포함) 특별약관', 'INJURY', '업무 및 출퇴근 중 사고 보장'),
(105, '1-4. 상해후유장해(3-100%)(1804) 특별약관', 'INJURY', '상해로 인한 후유장해 비율별 지급'),
(106, '1-5. 상해입원비(1일이상180일한도) 특별약관', 'INJURY', '상해 입원 일당 지급'),
(107, '1-6. 골절(치아파절제외)진단비 특별약관', 'INJURY', '골절 진단 시 회당 지급'),
(108, '1-7. 골절(치아파절제외)깁스치료비 특별약관', 'INJURY', '깁스 치료 시 비용 지원'),
(109, '1-8. 화상진단비 특별약관', 'INJURY', '화상 진단 시 가입금액 지급'),
(110, '1-9. 상해수술비 특별약관', 'INJURY', '상해로 인한 수술비 지원'),
(111, '1-10. 화상수술비 특별약관', 'INJURY', '화상 수술 시 비용 보장'),
(112, '1-11. 중증화상및부식진단비 특별약관', 'INJURY', '심각한 화상/부식 진단 시 보장'),
(113, '1-12. 업무상사고신체장해발생금(1-14급,차등지급) 특별약관', 'INJURY', '업무 사고 장해금'),
(114, '2. 비용손해관련 특별약관', 'LIVING', '각종 법적/경제적 비용 보장'),
(115, '2-1. 화재벌금(실손) 특별약관', 'LIVING', '화재로 인한 벌금 실손 보상'),
(116, '2-2. 가족화재벌금(실손) 특별약관', 'LIVING', '가족 화재 벌금 보장'),
(117, '2-3. 업무상과실·중과실치사상벌금(실손) 특별약관', 'LIVING', '업무상 과실 벌금 보장'),
(118, '2-4. 가족과실치사상벌금(실손) 특별약관', 'LIVING', '가족 과실 벌금 보장'),
(119, '2-5. 보이스피싱손해(실손) 특별약관', 'LIVING', '보이스피싱 피해 금액 보상'),
(120, '2-6. 민사소송법률비용Ⅱ(실손) 특별약관', 'LIVING', '민사 소송 비용 실손 지원');

-- ★ 매우 중요: ID를 직접 입력했으므로 다음 시퀀스 값을 최대값(120)으로 조정합니다.
SELECT setval('insurance_coverage_coverage_id_seq', (SELECT max(coverage_id) FROM insurance_coverage));

-- =====================================================
-- 3. 보험 상품(Product) 생성
-- =====================================================
INSERT INTO insurance_product (product_id, name, product_type, category, provider, base_price, description) VALUES 
(1, '한화 Bridge 자유 설계 종합', 'CUSTOM', 'LIVING', '한화손해보험', 1000, '무배당 한화 BigPlus 재산종합보험 기반 자유 설계'),
(2, '한화 1코노미 질병미니', 'MINI', 'DISEASE', '한화손해보험', 0, '질병 진단비에 집중한 실속형 미니보험'),
(3, '한화 BigPlus 상해미니', 'MINI', 'INJURY', '한화손해보험', 0, '무배당 한화 BigPlus 재산종합보험 (상해 집중형)'),
(4, '한화 1코노미 치아미니', 'MINI', 'DENTAL', '한화손해보험', 0, '꼭 필요한 치과 치료만 담은 미니보험'),
(5, '한화 1코노미 운전자미니', 'MINI', 'DRIVER', '한화손해보험', 0, '핵심 운전자 비용만 담은 가성비 보험'),
(6, '한화 BigPlus 생활미니', 'MINI', 'LIVING', '한화손해보험', 0, '무배당 한화 BigPlus 재산종합보험 (비용손해 집중형)');

SELECT setval('insurance_product_product_id_seq', (SELECT max(product_id) FROM insurance_product));

-- =====================================================
-- 4. 상품-담보 연결 (Link)
-- =====================================================
-- 이제 coverage_id를 100, 101... 로 호출해서 사용합니다.

-- 상해미니 (ID 3)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
VALUES (3, 100, 0, 0, TRUE, FALSE); -- 보통약관 필수

INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 3, coverage_id, 10000000, 800, FALSE, 
       (CASE WHEN coverage_id IN (103, 105, 107, 110) THEN TRUE ELSE FALSE END)
FROM insurance_coverage WHERE coverage_id BETWEEN 101 AND 113;

-- 생활미니 (ID 6)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
VALUES (6, 100, 0, 0, TRUE, FALSE); -- 보통약관 필수

INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 6, coverage_id, 20000000, 1500, FALSE, 
       (CASE WHEN coverage_id IN (115, 119) THEN TRUE ELSE FALSE END)
FROM insurance_coverage WHERE coverage_id BETWEEN 114 AND 120;

-- 자유 설계 종합 (ID 1)
INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
VALUES (1, 100, 0, 0, TRUE, FALSE); -- 보통약관 필수

INSERT INTO product_coverage_link (product_id, coverage_id, amount, monthly_price, is_mandatory, is_recommended)
SELECT 1, coverage_id, 10000000, 2000, FALSE, FALSE 
FROM insurance_coverage WHERE coverage_id <> 100;