drop trigger after_release_request_insert;

-- 출고요청이 등록되면 자동으로 출고검수도 등록되는 트리거
DELIMITER $$
CREATE TRIGGER after_release_request_insert
AFTER INSERT ON release_request
FOR EACH ROW
BEGIN
    -- inspection 테이블에 새로운 튜플을 생성
    INSERT INTO release_inspection (release_insptId, release_reqId, inspection_result, member_id, inspection_note)
    VALUES (
        CONCAT('RI', DATE_FORMAT(NOW(), '%Y%m%d%H%i'), LPAD(FLOOR(RAND() * 10000), 4, '0')),                             -- 자동 생성된 ID (UUID를 사용한 예시)
        NEW.release_reqId,                  -- 방금 등록된 release_request_id
        '처리중',                    -- 초기 상태는 '처리중'
        ifnull(member_id, '검수대기중'),
        ifnull(inspection_note, '검수대기중')
    );
END $$

DELIMITER ;

-- 출고요청이 삭제되면 자동으로 출고검수도 삭제되는 트리거
DELIMITER $$
CREATE TRIGGER after_release_request_delete
AFTER DELETE ON release_request
FOR EACH ROW
BEGIN
    DELETE from release_inspection where release_reqId = OLD.release_reqId;
END $$

DELIMITER ;