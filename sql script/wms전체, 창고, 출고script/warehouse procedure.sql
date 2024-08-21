-- drop procedure registerWarehouse;
DELIMITER $$

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