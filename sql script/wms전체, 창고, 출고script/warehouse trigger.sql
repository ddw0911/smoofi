-- 섹션이 등록되면 등록된 섹션의 수용량만큼 창고의 가용량을 차감하는 트리거
DELIMITER $$
CREATE TRIGGER update_warehouse_available
AFTER INSERT ON section
FOR EACH ROW
BEGIN
    UPDATE warehouse
    SET warehouse_available = warehouse_available - NEW.section_capacity
    WHERE warehouse_id = NEW.warehouse_id;
END$$
DELIMITER ;

-- 섹션의 수용량이 변경되면 변경값만큼 창고의 가용량도 변경시키는 트리거
DELIMITER $$
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

-- 섹션의 규격(가로,세로,높이)이 변경되면 수용가능량이 변경되는 트리거
DELIMITER $$

CREATE TRIGGER update_section_capacity_on_update_section
BEFORE UPDATE ON section
FOR EACH ROW
BEGIN
    UPDATE section
    SET NEW.section_capacity = NEW.section_width * NEW.section_height * NEW.section_length
    WHERE warehouse_id = NEW.warehouse_id;
END$$

DELIMITER ;


-- 섹션이 제거되었을때 섹션의 수용량을 다시 창고 가용량에 더해넣는 트리거
DELIMITER $$
CREATE TRIGGER update_warehouse_available_on_delete
AFTER DELETE ON section
FOR EACH ROW
BEGIN
    UPDATE warehouse
    SET warehouse_available = warehouse_available + OLD.section_capacity
    WHERE warehouse_id = OLD.warehouse_id;
END$$

DELIMITER ;
commit;