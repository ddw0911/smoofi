
DELIMITER $$
-- 출고검수가 통과되면 출고등록되는 트리거
CREATE TRIGGER after_release_inspection_approved
AFTER UPDATE ON release_inspection
FOR EACH ROW
BEGIN
    IF New.inspection_result = '승인' THEN
    INSERT dispatch (dispatch_id, dispatch_status)
    VALUES (
        CONCAT(RL, DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),                             -- 자동 생성된 ID (UUID를 사용한 예시)
        OLD.release_reqId,                  -- 검수했던 release_request_id
        now(),
        NEW.member_id -- 출고지시자
    );
    END IF;
END $$

DELIMITER ;


DELIMITER $$
-- 출고가 등록되면 배차신청이 되는 트리거
CREATE TRIGGER after_release_registered
AFTER INSERT ON releases
FOR EACH ROW
BEGIN
    INSERT dispatch (dispatch_id, dispatch_status)
    VALUES (
        CONCAT(DP, DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),                             -- 자동 생성된 ID (UUID를 사용한 예시)
        '처리중' -- 배차등록여부 초기화
    );
END $$

DELIMITER ;

-- 출고가 삭제되면 자동으로 연계된 배차정보, 운송장정보도 삭제되는 트리거
DELIMITER $$

CREATE TRIGGER after_release_delete
AFTER DELETE ON releases
FOR EACH ROW
BEGIN
    DELETE FROM dispatch WHERE release_id = OLD.release_id;
    DELETE FROM waybill WHERE release_id = OLD.release_id;
END $$

DELIMITER ;


DELIMITER $$
-- 배차상태가 "APPROVED" 되면 운송장이 자동등록되는 트리거
CREATE TRIGGER after_dispatch_status_approved
AFTER UPDATE ON dispatch
FOR EACH ROW
BEGIN
    IF New.dispatch_status = '승인' THEN
    INSERT waybill (waybill_id, release_id, delivery_status)
    VALUES (
        CONCAT(WB, DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),                             -- 자동 생성된 ID (UUID를 사용한 예시)
        dispatch.release_id,                  -- 검수했던 release_request_id
        '배송준비중' -- 배송상태를 배송준비중으로 초기화
    );
    END IF;
END $$

DELIMITER ;


DELIMITER $$
-- 운송장(waybill)의 출발날짜(departure_date)가 UPDATE 되면 배송상태가 "ON_DELIVERY"로 UPDATE 되는 트리거
CREATE TRIGGER after_waybill_departure_date_update
AFTER UPDATE ON waybill
FOR EACH ROW
BEGIN
    IF New.departure_date is not null THEN
    UPDATE waybill
    SET delivery_status = '배송중'
    where waybill_id = OLD.waybill_id;
    END IF;
END $$