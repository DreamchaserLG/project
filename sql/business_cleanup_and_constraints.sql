CREATE DATABASE IF NOT EXISTS project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `project_db`;

CREATE TABLE IF NOT EXISTS `business_data_cleanup_backup` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `row_id` varchar(100) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `snapshot_json` longtext,
  `backup_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cleanup_backup_table_row` (`table_name`, `row_id`),
  KEY `idx_cleanup_backup_time` (`backup_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `business_data_cleanup_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `row_id` varchar(100) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `action` varchar(50) NOT NULL DEFAULT 'LOGICAL_DELETE',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cleanup_log_table_row` (`table_name`, `row_id`),
  KEY `idx_cleanup_log_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP PROCEDURE IF EXISTS add_column_if_missing;
DELIMITER $$
CREATE PROCEDURE add_column_if_missing(
  IN p_table_name varchar(64),
  IN p_column_name varchar(64),
  IN p_column_definition text
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = p_table_name
      AND column_name = p_column_name
  ) THEN
    SET @add_column_sql = CONCAT('ALTER TABLE `', p_table_name, '` ADD COLUMN `', p_column_name, '` ', p_column_definition);
    PREPARE stmt_add_column FROM @add_column_sql;
    EXECUTE stmt_add_column;
    DEALLOCATE PREPARE stmt_add_column;
  END IF;
END$$
DELIMITER ;

CALL add_column_if_missing('exhibition_information', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('exhibition_information', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('exhibition_information', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
CALL add_column_if_missing('booth_information', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('booth_information', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('booth_information', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
CALL add_column_if_missing('registration_information', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('registration_information', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('registration_information', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
CALL add_column_if_missing('travel_confirmation', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('travel_confirmation', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('travel_confirmation', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
CALL add_column_if_missing('refund_request', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('refund_request', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('refund_request', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
CALL add_column_if_missing('data_statistics', 'is_deleted', 'tinyint(1) NOT NULL DEFAULT 0 COMMENT ''逻辑删除''');
CALL add_column_if_missing('data_statistics', 'deleted_time', 'datetime DEFAULT NULL COMMENT ''逻辑删除时间''');
CALL add_column_if_missing('data_statistics', 'deleted_reason', 'varchar(500) DEFAULT '''' COMMENT ''逻辑删除原因''');
DROP PROCEDURE add_column_if_missing;

DROP TEMPORARY TABLE IF EXISTS tmp_dirty_registration;
CREATE TEMPORARY TABLE tmp_dirty_registration AS
SELECT ri.registration_information_id AS row_id,
       TRIM(BOTH '; ' FROM CONCAT(
         IF(ri.enrolled_user IS NULL OR ri.enrolled_user <= 0 OR u.user_id IS NULL, '无关联用户; ', ''),
         IF(ri.exhibitionconvention_number IS NULL OR ei.exhibition_information_id IS NULL, '无关联会展; ', ''),
         IF((ri.source_table = 'booth_information' AND (ri.source_id IS NULL OR bi.booth_information_id IS NULL))
             OR (ri.booth_number IS NOT NULL AND bno.booth_information_id IS NULL), '展位不存在; ', ''),
         IF(ri.number_of_registrations IS NULL OR ri.number_of_registrations < 1, '人数小于1; ', ''),
         IF(ri.registration_status IS NOT NULL AND ri.registration_status <> ''
             AND ri.registration_status NOT IN ('报名成功','已报名','候补中','候补审核中','已取消'), '非法报名状态; ', ''),
         IF(ri.examine_state NOT IN ('未审核','已通过','未通过'), '非法审核状态; ', ''),
         IF(ri.pay_state NOT IN ('未支付','已支付','退款中','已退款'), '非法支付状态; ', ''),
         IF(ri.booth_prices IS NULL OR ri.booth_prices < 0, '金额异常; ', '')
       )) AS reason
FROM registration_information ri
LEFT JOIN `user` u ON u.user_id = ri.enrolled_user
LEFT JOIN exhibition_information ei ON ei.exhibitionconvention_number = ri.exhibitionconvention_number AND IFNULL(ei.is_deleted, 0) = 0
LEFT JOIN booth_information bi ON bi.booth_information_id = ri.source_id AND IFNULL(bi.is_deleted, 0) = 0
LEFT JOIN booth_information bno ON bno.booth_number = ri.booth_number AND IFNULL(bno.is_deleted, 0) = 0
WHERE IFNULL(ri.is_deleted, 0) = 0;

DELETE FROM tmp_dirty_registration WHERE reason = '';

INSERT INTO business_data_cleanup_backup(table_name, row_id, reason, snapshot_json)
SELECT 'registration_information', row_id, reason,
       (SELECT JSON_OBJECT(
          'registration_information_id', ri.registration_information_id,
          'order_number', ri.order_number,
          'booth_number', ri.booth_number,
          'exhibitionconvention_number', ri.exhibitionconvention_number,
          'enrolled_user', ri.enrolled_user,
          'number_of_registrations', ri.number_of_registrations,
          'registration_status', ri.registration_status,
          'examine_state', ri.examine_state,
          'pay_state', ri.pay_state,
          'booth_prices', ri.booth_prices
        ) FROM registration_information ri WHERE ri.registration_information_id = row_id)
FROM tmp_dirty_registration;

INSERT INTO business_data_cleanup_log(table_name, row_id, reason)
SELECT 'registration_information', row_id, reason FROM tmp_dirty_registration;

UPDATE registration_information ri
JOIN tmp_dirty_registration d ON d.row_id = ri.registration_information_id
SET ri.is_deleted = 1,
    ri.deleted_time = NOW(),
    ri.deleted_reason = d.reason,
    ri.update_time = NOW();

DROP TEMPORARY TABLE IF EXISTS tmp_dirty_travel;
CREATE TEMPORARY TABLE tmp_dirty_travel AS
SELECT tc.travel_confirmation_id AS row_id,
       TRIM(BOTH '; ' FROM CONCAT(
         IF(tc.enrolled_user IS NULL OR tc.enrolled_user <= 0 OR u.user_id IS NULL, '无关联用户; ', ''),
         IF(ri.registration_information_id IS NULL, '无报名关联; ', ''),
         IF(tc.number_of_attendees IS NULL OR tc.number_of_attendees < 1, '人数小于1; ', ''),
         IF(ri.registration_information_id IS NOT NULL AND tc.number_of_attendees > ri.number_of_registrations, '到场人数超过报名人数; ', ''),
         IF(tc.examine_state NOT IN ('未审核','已通过','未通过'), '非法审核状态; ', '')
       )) AS reason
FROM travel_confirmation tc
LEFT JOIN registration_information ri
  ON ((tc.source_table = 'registration_information' AND tc.source_id = ri.registration_information_id) OR tc.order_number = ri.order_number)
  AND IFNULL(ri.is_deleted, 0) = 0
LEFT JOIN `user` u ON u.user_id = tc.enrolled_user
WHERE IFNULL(tc.is_deleted, 0) = 0;

DELETE FROM tmp_dirty_travel WHERE reason = '';

INSERT INTO business_data_cleanup_backup(table_name, row_id, reason, snapshot_json)
SELECT 'travel_confirmation', row_id, reason,
       (SELECT JSON_OBJECT(
          'travel_confirmation_id', tc.travel_confirmation_id,
          'order_number', tc.order_number,
          'source_id', tc.source_id,
          'enrolled_user', tc.enrolled_user,
          'number_of_attendees', tc.number_of_attendees,
          'examine_state', tc.examine_state
        ) FROM travel_confirmation tc WHERE tc.travel_confirmation_id = row_id)
FROM tmp_dirty_travel;

INSERT INTO business_data_cleanup_log(table_name, row_id, reason)
SELECT 'travel_confirmation', row_id, reason FROM tmp_dirty_travel;

UPDATE travel_confirmation tc
JOIN tmp_dirty_travel d ON d.row_id = tc.travel_confirmation_id
SET tc.is_deleted = 1,
    tc.deleted_time = NOW(),
    tc.deleted_reason = d.reason,
    tc.update_time = NOW();

DROP TEMPORARY TABLE IF EXISTS tmp_dirty_refund;
CREATE TEMPORARY TABLE tmp_dirty_refund AS
SELECT rr.refund_request_id AS row_id,
       TRIM(BOTH '; ' FROM CONCAT(
         IF(rr.enrolled_user IS NULL OR rr.enrolled_user <= 0 OR u.user_id IS NULL, '无关联用户; ', ''),
         IF(ri.registration_information_id IS NULL, '无关联订单; ', ''),
         IF(rr.booth_prices IS NULL OR rr.booth_prices <= 0, '退款金额小于等于0; ', ''),
         IF(ri.registration_information_id IS NOT NULL AND rr.booth_prices > ri.booth_prices, '退款金额超过成交金额; ', ''),
         IF(rr.examine_state NOT IN ('未审核','已通过','未通过'), '非法审核状态; ', '')
       )) AS reason
FROM refund_request rr
LEFT JOIN registration_information ri
  ON ((rr.source_table = 'registration_information' AND rr.source_id = ri.registration_information_id) OR rr.order_number = ri.order_number)
  AND IFNULL(ri.is_deleted, 0) = 0
LEFT JOIN `user` u ON u.user_id = rr.enrolled_user
WHERE IFNULL(rr.is_deleted, 0) = 0;

DELETE FROM tmp_dirty_refund WHERE reason = '';

INSERT INTO business_data_cleanup_backup(table_name, row_id, reason, snapshot_json)
SELECT 'refund_request', row_id, reason,
       (SELECT JSON_OBJECT(
          'refund_request_id', rr.refund_request_id,
          'order_number', rr.order_number,
          'source_id', rr.source_id,
          'enrolled_user', rr.enrolled_user,
          'booth_prices', rr.booth_prices,
          'examine_state', rr.examine_state
        ) FROM refund_request rr WHERE rr.refund_request_id = row_id)
FROM tmp_dirty_refund;

INSERT INTO business_data_cleanup_log(table_name, row_id, reason)
SELECT 'refund_request', row_id, reason FROM tmp_dirty_refund;

UPDATE refund_request rr
JOIN tmp_dirty_refund d ON d.row_id = rr.refund_request_id
SET rr.is_deleted = 1,
    rr.deleted_time = NOW(),
    rr.deleted_reason = d.reason,
    rr.update_time = NOW();

DROP PROCEDURE IF EXISTS add_check_if_missing;
DELIMITER $$
CREATE PROCEDURE add_check_if_missing(
  IN p_table_name varchar(64),
  IN p_constraint_name varchar(64),
  IN p_constraint_sql text
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_schema = DATABASE()
      AND table_name = p_table_name
      AND constraint_name = p_constraint_name
  ) THEN
    SET @add_check_sql = CONCAT('ALTER TABLE `', p_table_name, '` ADD CONSTRAINT `', p_constraint_name, '` CHECK (', p_constraint_sql, ')');
    PREPARE stmt_add_check FROM @add_check_sql;
    EXECUTE stmt_add_check;
    DEALLOCATE PREPARE stmt_add_check;
  END IF;
END$$
DELIMITER ;

CALL add_check_if_missing('registration_information', 'chk_registration_people_min', '`number_of_registrations` >= 1');
CALL add_check_if_missing('registration_information', 'chk_registration_people_integer', '`number_of_registrations` = FLOOR(`number_of_registrations`)');
CALL add_check_if_missing('registration_information', 'chk_registration_amount_min', '`booth_prices` >= 0');
CALL add_check_if_missing('registration_information', 'chk_registration_deleted_flag', '`is_deleted` IN (0, 1)');
CALL add_check_if_missing('travel_confirmation', 'chk_travel_attendee_min', '`number_of_attendees` >= 1');
CALL add_check_if_missing('travel_confirmation', 'chk_travel_attendee_integer', '`number_of_attendees` = FLOOR(`number_of_attendees`)');
CALL add_check_if_missing('travel_confirmation', 'chk_travel_deleted_flag', '`is_deleted` IN (0, 1)');
CALL add_check_if_missing('refund_request', 'chk_refund_amount_positive', '`booth_prices` > 0');
CALL add_check_if_missing('refund_request', 'chk_refund_deleted_flag', '`is_deleted` IN (0, 1)');
CALL add_check_if_missing('booth_information', 'chk_booth_price_positive', '`booth_prices` > 0');
CALL add_check_if_missing('booth_information', 'chk_booth_capacity_nonnegative', '`registration_information_limit_times` >= 0');
CALL add_check_if_missing('booth_information', 'chk_booth_deleted_flag', '`is_deleted` IN (0, 1)');
CALL add_check_if_missing('exhibition_information', 'chk_exhibition_deleted_flag', '`is_deleted` IN (0, 1)');
CALL add_check_if_missing('data_statistics', 'chk_data_statistics_deleted_flag', '`is_deleted` IN (0, 1)');
DROP PROCEDURE add_check_if_missing;

DROP PROCEDURE IF EXISTS add_index_if_missing;
DELIMITER $$
CREATE PROCEDURE add_index_if_missing(
  IN p_table_name varchar(64),
  IN p_index_name varchar(64),
  IN p_index_sql text
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = p_table_name
      AND index_name = p_index_name
  ) THEN
    SET @add_index_sql = CONCAT('ALTER TABLE `', p_table_name, '` ADD INDEX `', p_index_name, '` (', p_index_sql, ')');
    PREPARE stmt_add_index FROM @add_index_sql;
    EXECUTE stmt_add_index;
    DEALLOCATE PREPARE stmt_add_index;
  END IF;
END$$
DELIMITER ;

CALL add_index_if_missing('registration_information', 'idx_registration_deleted', '`is_deleted`');
CALL add_index_if_missing('travel_confirmation', 'idx_travel_deleted', '`is_deleted`');
CALL add_index_if_missing('refund_request', 'idx_refund_deleted', '`is_deleted`');
CALL add_index_if_missing('booth_information', 'idx_booth_deleted', '`is_deleted`');
CALL add_index_if_missing('exhibition_information', 'idx_exhibition_deleted', '`is_deleted`');
DROP PROCEDURE add_index_if_missing;
