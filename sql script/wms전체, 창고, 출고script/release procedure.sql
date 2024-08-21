-- drop procedure GetMemberReleaseStatus;

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