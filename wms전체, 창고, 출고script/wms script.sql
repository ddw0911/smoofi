CREATE TABLE `member` (
	`member_id`	varchar(20)	NOT NULL,
	`member_name`	varchar(20)	NOT NULL,
	`member_password`	varchar(20)	NOT NULL,
	`member_phoneNumber`	varchar(13)	NOT NULL,
	`member_email`	varchar(30)	NOT NULL,
	`member_address`	varchar(50)	NOT NULL,
	`member_type`	enum("일반회원","배송기사","관리자")	NOT NULL,
	`member_status`	enum("활성","비활성","비활성 요청") default "활성"	NOT NULL,
	`approval`	enum("true","false") default "false"	NOT NULL,
	`createAt`	datetime	NOT NULL,
	`lastLogin`	datetime	NOT NULL,
	`business_name`	varchar(20)	NOT NULL,
	`business_address`	varchar(50)	NULL,
	`warehouse_name`	varchar(30)	NULL,
	`truck_type`	enum("냉장","냉동","일반")	NULL,
	`truck_number`	varchar(30)	NULL
);

CREATE TABLE `approval_history` (
	`terms_code`	varchar(2)	NOT NULL,
	`member_id`	varchar(20)	NOT NULL,
	`agreement`	varchar(1)	NULL,
	`agree_date`	datetime	NULL
);

CREATE TABLE `terms_of_information` (
	`terms_code`	varchar(2)	NOT NULL,
	`terms_name`	varchar(20)	NULL,
	`terms_content`	varchar(1000)	NULL,
	`requirement_or_not`	varchar(1)	NULL
);

CREATE TABLE `product` (
	`product_id`	varchar(10)	NOT NULL,
	`product_name`	varchar(30)	NOT NULL,
	`price`	int	NOT NULL,
	`brand`	varchar(30)	NOT NULL,
	`product_width`	int	NOT NULL,
	`product_length`	int	NOT NULL,
	`product_height`	int	NOT NULL,
	`designate_medication_status`	char(1)	NOT NULL,
	`storage_method`	enum("normal","cold","freeze","designated")	NOT NULL,
	`formulation`	enum("oral","external")	NOT NULL
);

CREATE TABLE `stock` (
	`product_lotno`	varchar(30)	NOT NULL,
	`product_name`	varchar(30)	NOT NULL,
	`total`	int	NOT NULL,
	`product_id`	varchar(10)	NOT NULL,
	`section_id`	varchar(20)	NOT NULL,
	`warehouse_id`	VARCHAR(30)	NOT NULL
);

CREATE TABLE `stock_taking` (
	`stocktaking_id`	varchar(20)	NOT NULL,
	`warehouse_id`	varchar(20)	NOT NULL,
	`product_id`	varchar(30)	NOT NULL,
	`product_name`	varchar(30)	NOT NULL,
	`lotno`	varchar(30)	NOT NULL,
	`computerized_stock`	int	NOT NULL,
	`physical_stock`	int	NOT NULL,
	`difference_quantity`	int	NOT NULL,
	`stocktaking_date`	date	NOT NULL,
	`note`	varchar(100)	NULL
);

CREATE TABLE `revenue` (
	`revenue_id`	varchar(20)	NOT NULL,
	`warehouse_id`	VARCHAR(30)	NOT NULL,
	`revenue_date`	datetime	NOT NULL,
	`revenue_charge`	int	NOT NULL,
	`revenue_category`	varchar(30)	NOT NULL,
	`note`	varchar(100)	NULL
);

CREATE TABLE `expenditure` (
	`expenditure_id`	varchar(20)	NOT NULL,
	`warehouse_id`	VARCHAR(30)	NOT NULL,
	`expenditure_date`	date	NOT NULL,
	`expenditure_charge`	int	NOT NULL,
	`expenditure_category`	varchar(30)	NOT NULL,
	`note`	varchar(100)	NULL
);

CREATE TABLE `stock_history` (
	`history_id`	varchar(20)	NOT NULL,
	`assortment`	enum("in","out")	NOT NULL,
	`product_name`	varchar(30)	NOT NULL,
	`before_amount`	int	NOT NULL,
	`amount`	int	NOT NULL,
	`after_amount`	int	NOT NULL,
	`history_date`	datetime	NOT NULL
);

CREATE TABLE `section` (
	`section_id`	varchar(20)	NOT NULL,
	`warehouse_id`	VARCHAR(30)	NOT NULL,
	`section_width`	int	NOT NULL,
	`section_length`	int	NOT NULL,
	`section_height`	int	NOT NULL,
	`section_type`	ENUM("냉장",  "냉동", "실온")	NOT NULL,
	`section_capacity`	int	NOT NULL,
	`section_note`	varchar(50)	NULL
);

CREATE TABLE `counting` (
	`stocktaking_id`	varchar(20)	NOT NULL,
	`product_lotno`	varchar(30)	NOT NULL
);

CREATE TABLE `costMaster` (
	`cost_id`	varchar(20)	NOT NULL,
	`cost_name`	varchar(30)	NOT NULL,
	`cost`	int	NOT NULL
);

CREATE TABLE `inboundRequest` (
	`request_id`	int	NOT NULL,
	`reqeust_date`	date	NOT NULL,
	`product_quantity`	int	NOT NULL,
	`product_id`	varchar(10)	NOT NULL,
	`member_id`	varchar(20)	NOT NULL
);

CREATE TABLE `inboundInspection` (
	`request_id`	int	NOT NULL,
	`inspection_date`	date	NULL,
	`insepction_status`	enum("InProgress", "Pending", "Completed")	NULL,
	`member_id`	varchar(20)	NULL
);

CREATE TABLE `inboundApproval` (
	`request_id`	int	NOT NULL,
	`approval_date`	date	NULL,
	`approval_status`	enum("InProgress","Pending","Completed")	NULL,
	`approver_id`	varchar(20)	NULL
);

CREATE TABLE `release_request` (
	`release_reqId`	VARCHAR(30)	NOT NULL,
	`release_req_date`	DATETIME	NOT NULL,
	`member_id`	varchar(20)	NOT NULL,
	`product_lotno`	varchar(30)	NOT NULL,
	`order_quantity`	int	NOT NULL,
	`customer_name`	varchar(30)	NOT NULL,
	`customer_address`	VARCHAR(100)	NOT NULL,
	`customer_phone`	VARCHAR(20)	NOT NULL,
	`customer_requirement`	VARCHAR(100)	NULL,
	`release_req_status`	ENUM("처리중",  "승인", "거절")	NOT NULL,
	`release_req_note`	VARCHAR(255)	NULL
);

CREATE TABLE `release_output` (
	`release_printId`	VARCHAR(30)	NOT NULL,
	`release_id`	VARCHAR(30)	NOT NULL,
	`note`	VARCHAR(50)	NULL,
	`vehicle_id`	VARCHAR(15)	NOT NULL
);

CREATE TABLE `waybill` (
	`waybill_id`	VARCHAR(30)	NOT NULL,
	`release_id`	VARCHAR(30)	NOT NULL,
	`delivery_status`	ENUM("배송중","배송준비중","배송완료")	NOT NULL,
	`departure_date`	DATE	NULL,
	`waybill_note`	VARCHAR(50)	NULL
);

CREATE TABLE `dispatch` (
	`dispatch_id`	VARCHAR(30)	NOT NULL,
	`vehicle_id`	VARCHAR(15)	NOT NULL,
	`dispatch_status`	ENUM("처리중", "승인", "거절")	NOT NULL,
	`member_id`	varchar(20)	NOT NULL,
	`dispatch_regiDate`	DATETIME	NULL,
	`note`	VARCHAR(50)	NULL
);

CREATE TABLE `task_Log` (
	`log_id`	int	NOT NULL	COMMENT 'auto_increment',
	`task_id`	VARCHAR(30)	NOT NULL,
	`task_type`	CHAR(5)	NOT NULL,
	`task_date`	DATETIME	NOT NULL,
	`member_id`	VARCHAR(20)	NOT NULL
);

CREATE TABLE `release_inspection` (
	`release_insptId`	VARCHAR(30)	NOT NULL,
	`release_reqId`	VARCHAR(30)	NOT NULL,
	`inspection_result`	ENUM("처리중", "승인", "거절")	NOT NULL,
	`member_id`	varchar(20)	NULL,
	`inspection_time`	DATETIME	NULL,
	`inspection_note`	VARCHAR(255)	NULL
);

CREATE TABLE `releases` (
	`release_id`	VARCHAR(30)	NOT NULL,
	`release_reqId`	VARCHAR(30)	NOT NULL,
	`dispatch_id`	VARCHAR(30)	NOT NULL,
	`release_date`	DATE	NOT NULL,
	`member_id`	varchar(20)	NOT NULL,
	`release_note`	VARCHAR(50)	NULL
);

CREATE TABLE `warehouse` (
	`warehouse_id`	VARCHAR(30)	NOT NULL,
	`warehouse_name`	varchar(30)	NOT NULL,
	`warehouse_address`	varchar(70)	NOT NULL,
	`warehouse_contact`	varchar(20)	NOT NULL,
	`warehouse_capacity`	int	NOT NULL,
	`warehouse_available`	int	NOT NULL,
	`warehouse_regi_date`	date	NOT NULL,
	`member_id`	varchar(20)	NOT NULL,
	`warehouse_note`	varchar(50)	NULL
);

ALTER TABLE `member` ADD CONSTRAINT `PK_MEMBER` PRIMARY KEY (
	`member_id`
);

ALTER TABLE `approval_history` ADD CONSTRAINT `PK_APPROVAL_HISTORY` PRIMARY KEY (
	`terms_code`,
	`member_id`
);

ALTER TABLE `terms_of_information` ADD CONSTRAINT `PK_TERMS_OF_INFORMATION` PRIMARY KEY (
	`terms_code`
);

ALTER TABLE `product` ADD CONSTRAINT `PK_PRODUCT` PRIMARY KEY (
	`product_id`
);

ALTER TABLE `stock` ADD CONSTRAINT `PK_STOCK` PRIMARY KEY (
	`product_lotno`
);

ALTER TABLE `stock_taking` ADD CONSTRAINT `PK_STOCK_TAKING` PRIMARY KEY (
	`stocktaking_id`
);

ALTER TABLE `revenue` ADD CONSTRAINT `PK_REVENUE` PRIMARY KEY (
	`revenue_id`,
	`warehouse_id`
);

ALTER TABLE `expenditure` ADD CONSTRAINT `PK_EXPENDITURE` PRIMARY KEY (
	`expenditure_id`,
	`warehouse_id`
);

ALTER TABLE `stock_history` ADD CONSTRAINT `PK_STOCK_HISTORY` PRIMARY KEY (
	`history_id`
);

ALTER TABLE `section` ADD CONSTRAINT `PK_SECTION` PRIMARY KEY (
	`section_id`
);

ALTER TABLE `counting` ADD CONSTRAINT `PK_COUNTING` PRIMARY KEY (
	`stocktaking_id`,
	`product_lotno`
);

ALTER TABLE `costMaster` ADD CONSTRAINT `PK_COSTMASTER` PRIMARY KEY (
	`cost_id`
);

ALTER TABLE `inboundRequest` ADD CONSTRAINT `PK_INBOUNDREQUEST` PRIMARY KEY (
	`request_id`
);

ALTER TABLE `inboundInspection` ADD CONSTRAINT `PK_INBOUNDINSPECTION` PRIMARY KEY (
	`request_id`
);

ALTER TABLE `inboundApproval` ADD CONSTRAINT `PK_INBOUNDAPPROVAL` PRIMARY KEY (
	`request_id`
);

ALTER TABLE `release_request` ADD CONSTRAINT `PK_RELEASE_REQUEST` PRIMARY KEY (
	`release_reqId`
);

ALTER TABLE `release_output` ADD CONSTRAINT `PK_RELEASE_OUTPUT` PRIMARY KEY (
	`release_printId`
);

ALTER TABLE `waybill` ADD CONSTRAINT `PK_WAYBILL` PRIMARY KEY (
	`waybill_id`
);

ALTER TABLE `dispatch` ADD CONSTRAINT `PK_DISPATCH` PRIMARY KEY (
	`dispatch_id`,
	`vehicle_id`
);

ALTER TABLE `task_Log` ADD CONSTRAINT `PK_TASK_LOG` PRIMARY KEY (
	`log_id`,
	`task_id`
);

ALTER TABLE `release_inspection` ADD CONSTRAINT `PK_RELEASE_INSPECTION` PRIMARY KEY (
	`release_insptId`
);

ALTER TABLE `releases` ADD CONSTRAINT `PK_RELEASES` PRIMARY KEY (
	`release_id`
);

ALTER TABLE `warehouse` ADD CONSTRAINT `PK_WAREHOUSE` PRIMARY KEY (
	`warehouse_id`
);

ALTER TABLE `approval_history` ADD CONSTRAINT `FK_terms_of_information_TO_approval_history_1` FOREIGN KEY (
	`terms_code`
)
REFERENCES `terms_of_information` (
	`terms_code`
);

ALTER TABLE `approval_history` ADD CONSTRAINT `FK_member_TO_approval_history_1` FOREIGN KEY (
	`member_id`
)
REFERENCES `member` (
	`member_id`
);

ALTER TABLE `revenue` ADD CONSTRAINT `FK_warehouse_TO_revenue_1` FOREIGN KEY (
	`warehouse_id`
)
REFERENCES `warehouse` (
	`warehouse_id`
);

ALTER TABLE `expenditure` ADD CONSTRAINT `FK_warehouse_TO_expenditure_1` FOREIGN KEY (
	`warehouse_id`
)
REFERENCES `warehouse` (
	`warehouse_id`
);

ALTER TABLE `counting` ADD CONSTRAINT `FK_stock_taking_TO_counting_1` FOREIGN KEY (
	`stocktaking_id`
)
REFERENCES `stock_taking` (
	`stocktaking_id`
);

ALTER TABLE `counting` ADD CONSTRAINT `FK_stock_TO_counting_1` FOREIGN KEY (
	`product_lotno`
)
REFERENCES `stock` (
	`product_lotno`
);

