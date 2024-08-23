DELIMITER $$
-- 섹션이 등록되면 등록된 섹션의 수용량만큼 창고의 가용량을 차감하는 트리거
CREATE TRIGGER update_warehouse_available
AFTER INSERT ON section
FOR EACH ROW
BEGIN
    UPDATE warehouse
    SET warehouse_available = warehouse_available - NEW.section_capacity
    WHERE warehouse_id = NEW.warehouse_id;
END$$
DELIMITER ;

DELIMITER $$
-- 섹션의 수용량이 변경되면 변경값만큼 창고의 가용량도 변경시키는 트리거
CREATE TRIGGER update_warehouse_available_on_update
AFTER UPDATE ON section
FOR EACH ROW
BEGIN
    DECLARE capacity_difference INT;

    -- 섹션 수용량의 변화량 계산
    SET capacity_difference = NEW.section_capacity - OLD.section_capacity;

    -- 창고의 총수용량 조정
    UPDATE warehouse
    SET warehouse_available = warehouse_available - capacity_difference
    WHERE warehouse_id = NEW.warehouse_id;
END$$

DELIMITER ;
-- 섹션의 길이가 수정되면 수용량도 수정되는 트리거
DELIMITER $$
CREATE TRIGGER before_update_section_capacity
BEFORE UPDATE ON section
FOR EACH ROW
BEGIN
    SET NEW.section_capacity = NEW.section_width * NEW.section_height * NEW.section_length;
END$$
DELIMITER ;

DELIMITER $$
-- 섹션이 제거되었을때 섹션의 수용량을 다시 창고 가용량에 더해넣는 트리거
CREATE TRIGGER update_warehouse_available_on_delete
AFTER DELETE ON section
FOR EACH ROW
BEGIN
    UPDATE warehouse
    SET warehouse_available = warehouse_available + OLD.section_capacity
    WHERE warehouse_id = OLD.warehouse_id;
END$$

DELIMITER ;


DELIMITER $$
-- 창고등록 프로시져
CREATE PROCEDURE registerWarehouse(
    IN p_warehouse_id VARCHAR(30),
    IN p_warehouse_name VARCHAR(30),
    IN p_warehouse_address VARCHAR(70),
    IN p_warehouse_contact VARCHAR(20),
    IN p_warehouse_capacity int,
    IN p_warehouse_available int,
    IN p_warehouse_regi_date date,
    IN p_member_id VARCHAR(20),
    IN p_warehouse_note VARCHAR(50)
)
BEGIN
    
    -- warehouse_id 중복검사
    IF EXISTS (SELECT 1 FROM warehouse WHERE warehouse_id = p_warehouse_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '창고 ID가 이미 존재합니다.';
    END IF;
    
    -- warehouse_name 중복검사
    IF EXISTS (SELECT 1 FROM warehouse WHERE warehouse_name = p_warehouse_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '창고 이름이 이미 존재합니다.';
    END IF;
    
    -- warehouse_capacity가 음수로 입력되었는지 검사
    IF p_warehouse_capacity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '창고수용량은 양수여야 합니다.';
    END IF;
    
    -- member_id 유효성 검사
    IF NOT EXISTS (SELECT 1 FROM member WHERE member_id = p_member_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '해당 ID가 존재하지 않습니다.';
    END IF;

    -- 속성에 데이터 입력
    INSERT INTO warehouse (
        warehouse_id, warehouse_name, warehouse_address, warehouse_contact, 
        warehouse_capacity, warehouse_available, warehouse_regi_date, member_id, warehouse_note
    ) VALUES (
        p_warehouse_id, p_warehouse_name, p_warehouse_address, p_warehouse_contact, 
        p_warehouse_capacity, p_warehouse_available, p_warehouse_regi_date, p_member_id, p_warehouse_note
    );

END $$

DELIMITER ;

DELIMITER $$
-- 출고요청이 등록되면 자동으로 출고검수도 등록되는 트리거
CREATE TRIGGER after_release_request_insert
AFTER INSERT ON release_request
FOR EACH ROW
BEGIN
    -- inspection 테이블에 새로운 튜플을 생성
    INSERT INTO release_inspection (release_insptId, release_reqId)
    VALUES (
        CONCAT('RI', DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),                
        NEW.release_reqId            -- 방금 등록된 release_request_id
    );
END $$

DELIMITER ;


DELIMITER $$
-- 출고요청이 삭제되면 자동으로 출고검수도 삭제되는 트리거
CREATE TRIGGER after_release_request_delete
AFTER DELETE ON release_request
FOR EACH ROW
BEGIN
    DELETE from release_inspection where release_reqId = OLD.release_reqId;
END $$

DELIMITER ;

DELIMITER $$
-- 쇼핑몰(일반회원)이 자신의 출고현황을 조회(특정 데이터를 조회)하는 프로시져
CREATE PROCEDURE GetMemberReleaseStatus(IN p_member_id VARCHAR(20))
BEGIN
    SELECT 
		rr.release_reqId, -- 출고요청id
        rr.product_lotno, -- 출고물품번호
        rr.order_quantity, -- 주문수량
		ifnull(rl.release_date, ''), -- 출고날짜
        ifnull(wb.delivery_status, ''), -- 배송상태
		ifnull(wb.departure_date, '') -- 배송출발날짜
    FROM 
        release_request rr
    LEFT JOIN 
        releases rl ON rl.release_reqId = rr.release_reqId
	LEFT JOIN
		waybill wb ON rl.release_id = wb.release_id
    WHERE 
        rr.member_id = p_member_id
    ORDER BY 
        rl.release_date DESC;
END $$

DELIMITER ;

DELIMITER $$
-- 출고검수가 '승인'되면 출고요청상태를 '승인' 및 배차가 '등록'되는 트리거
CREATE TRIGGER after_release_inspection_approved
BEFORE UPDATE ON release_inspection
FOR EACH ROW
BEGIN
    IF New.inspection_result = '승인' THEN
		SET NEW.inspection_time = NOW(),
            NEW.member_id = (SELECT member_id FROM member WHERE member_type = '관리자' LIMIT 1),
            NEW.inspection_note = '배차등록됨';
    -- 출고요청 '승인' 상태로 변경
		UPDATE release_request SET release_req_status='승인' where release_reqId= NEW.release_reqId;
    -- 배차 등록
    INSERT dispatch (dispatch_id, vehicle_id, release_reqId, member_id, dispatch_note)
    VALUES(
		CONCAT('DP', DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
		'',
        OLD.release_reqId,
        '',
        ''
		);
    END IF;
END $$

DELIMITER ;

DELIMITER $$
-- 배차상태가 "승인" 되면 배차정보가 '수정' 되고 출고가 '등록'되는 트리거
CREATE TRIGGER after_dispatch_status_approved
BEFORE UPDATE ON dispatch
FOR EACH ROW
BEGIN
    IF New.dispatch_status = '승인' THEN
	SET NEW.dispatch_regiDate = now();
    SET NEW.member_id = (select member_id from member where member_type='배송기사' limit 1);
    -- 출고 등록
    INSERT releases (release_id, dispatch_id, release_date, member_id, release_note)
    VALUES (
        CONCAT('RL', DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
        OLD.dispatch_id,   
        now(),
        (SELECT member_id FROM member WHERE member_type = '관리자' LIMIT 1),
        '');
    END IF;
END $$

DELIMITER ;


DELIMITER $$
-- 운송장(waybill)의 출발날짜(departure_date)가 UPDATE 되면 배송상태가 "배송중"으로 UPDATE 되는 트리거
CREATE TRIGGER after_waybill_departure_date_update
BEFORE UPDATE ON waybill
FOR EACH ROW
BEGIN
    IF New.departure_date is not null THEN
    SET NEW.delivery_status = '배송중';
    END IF;
END $$


DELIMITER $$
-- 배차정보가 삭제되면 자동으로 연계된 출고, 운송장 정보도 삭제되는 트리거
CREATE TRIGGER after_dispatch_delete
AFTER DELETE ON dispatch
FOR EACH ROW
BEGIN
    DELETE FROM releases WHERE dispatch_id = OLD.dispatch_id;
    DELETE FROM waybill WHERE release_id = (select release_id from releases where dispatch_id = Old.dispatch_id);
END $$

DELIMITER ;