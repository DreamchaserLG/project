CREATE DATABASE IF NOT EXISTS project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `project_db`;

CREATE TABLE IF NOT EXISTS `user_track_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_name` varchar(50) NOT NULL,
  `page` varchar(500) DEFAULT NULL,
  `data_json` longtext,
  `user_id` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `user_role` varchar(50) DEFAULT NULL COMMENT '用户角色',
  `action_type` varchar(50) DEFAULT NULL COMMENT '操作类型',
  `object_type` varchar(100) DEFAULT NULL COMMENT '操作对象类型',
  `object_id` varchar(100) DEFAULT NULL COMMENT '操作对象ID',
  `ip` varchar(64) DEFAULT NULL COMMENT 'IP',
  `result` varchar(50) DEFAULT NULL COMMENT '操作结果',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_track_log_user_id` (`user_id`),
  KEY `idx_user_track_log_username` (`username`),
  KEY `idx_user_track_log_action` (`action_type`),
  KEY `idx_user_track_log_role` (`user_role`),
  KEY `idx_user_track_log_time` (`create_time`)
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
    SET @add_column_sql = CONCAT(
      'ALTER TABLE `', p_table_name, '` ADD COLUMN `', p_column_name, '` ', p_column_definition
    );
    PREPARE stmt_add_column FROM @add_column_sql;
    EXECUTE stmt_add_column;
    DEALLOCATE PREPARE stmt_add_column;
  END IF;
END$$
DELIMITER ;

CALL add_column_if_missing('user_track_log', 'user_role', 'varchar(50) DEFAULT NULL COMMENT ''用户角色''');
CALL add_column_if_missing('user_track_log', 'action_type', 'varchar(50) DEFAULT NULL COMMENT ''操作类型''');
CALL add_column_if_missing('user_track_log', 'object_type', 'varchar(100) DEFAULT NULL COMMENT ''操作对象类型''');
CALL add_column_if_missing('user_track_log', 'object_id', 'varchar(100) DEFAULT NULL COMMENT ''操作对象ID''');
CALL add_column_if_missing('user_track_log', 'ip', 'varchar(64) DEFAULT NULL COMMENT ''IP''');
CALL add_column_if_missing('user_track_log', 'result', 'varchar(50) DEFAULT NULL COMMENT ''操作结果''');
CALL add_column_if_missing('user_track_log', 'remark', 'varchar(500) DEFAULT NULL COMMENT ''备注''');

CALL add_column_if_missing('registration_information', 'extra', 'text COMMENT ''额外信息''');
CALL add_column_if_missing('registration_information', 'source_table', 'varchar(255) DEFAULT NULL COMMENT ''来源表''');
CALL add_column_if_missing('registration_information', 'source_id', 'int DEFAULT 0 COMMENT ''来源ID''');
CALL add_column_if_missing('registration_information', 'source_user_id', 'int DEFAULT 0 COMMENT ''来源用户''');
CALL add_column_if_missing('registration_information', 'registration_status', 'varchar(32) DEFAULT NULL COMMENT ''报名状态''');
CALL add_column_if_missing('registration_information', 'waitlist_no', 'int DEFAULT NULL COMMENT ''候补序号''');
CALL add_column_if_missing('registration_information', 'waitlist_time', 'datetime DEFAULT NULL COMMENT ''候补时间''');
CALL add_column_if_missing('registration_information', 'confirm_time', 'datetime DEFAULT NULL COMMENT ''确认时间''');
CALL add_column_if_missing('registration_information', 'cancel_time', 'datetime DEFAULT NULL COMMENT ''取消时间''');
CALL add_column_if_missing('registration_information', 'escalate_state', 'varchar(16) DEFAULT '''' COMMENT ''越级状态''');
CALL add_column_if_missing('registration_information', 'escalate_reason', 'varchar(500) DEFAULT '''' COMMENT ''越级原因''');

CALL add_column_if_missing('refund_request', 'extra', 'text COMMENT ''额外信息''');
CALL add_column_if_missing('refund_request', 'source_table', 'varchar(255) DEFAULT NULL COMMENT ''来源表''');
CALL add_column_if_missing('refund_request', 'source_id', 'int DEFAULT 0 COMMENT ''来源ID''');
CALL add_column_if_missing('refund_request', 'source_user_id', 'int DEFAULT 0 COMMENT ''来源用户''');
CALL add_column_if_missing('refund_request', 'escalate_state', 'varchar(16) DEFAULT '''' COMMENT ''申诉状态''');
CALL add_column_if_missing('refund_request', 'escalate_reason', 'varchar(500) DEFAULT '''' COMMENT ''申诉原因''');

CALL add_column_if_missing('travel_confirmation', 'extra', 'text COMMENT ''额外信息''');
CALL add_column_if_missing('travel_confirmation', 'source_table', 'varchar(255) DEFAULT NULL COMMENT ''来源表''');
CALL add_column_if_missing('travel_confirmation', 'source_id', 'int DEFAULT 0 COMMENT ''来源ID''');
CALL add_column_if_missing('travel_confirmation', 'source_user_id', 'int DEFAULT 0 COMMENT ''来源用户''');
CALL add_column_if_missing('travel_confirmation', 'examine_state', 'varchar(16) DEFAULT ''未审核'' NOT NULL COMMENT ''审核状态''');
CALL add_column_if_missing('travel_confirmation', 'examine_reply', 'varchar(255) DEFAULT '''' COMMENT ''审核回复''');

DROP PROCEDURE add_column_if_missing;

ALTER TABLE `registration_information`
  MODIFY COLUMN `number_of_registrations` double(8,2) DEFAULT 1 COMMENT '报名人数';

ALTER TABLE `travel_confirmation`
  MODIFY COLUMN `number_of_attendees` double(8,2) DEFAULT 1 COMMENT '到场人数';

SET @drop_registration_booth_number_index = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND index_name = 'booth_number'
    ),
    'ALTER TABLE `registration_information` DROP INDEX `booth_number`',
    'SELECT 1'
  )
);
PREPARE stmt_drop_registration_booth_number_index FROM @drop_registration_booth_number_index;
EXECUTE stmt_drop_registration_booth_number_index;
DEALLOCATE PREPARE stmt_drop_registration_booth_number_index;

SET @create_registration_booth_number_index = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND index_name = 'idx_registration_booth_number'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD INDEX `idx_registration_booth_number` (`booth_number`)'
  )
);
PREPARE stmt_create_registration_booth_number_index FROM @create_registration_booth_number_index;
EXECUTE stmt_create_registration_booth_number_index;
DEALLOCATE PREPARE stmt_create_registration_booth_number_index;

SET @create_registration_source_status_index = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND index_name = 'idx_registration_source_status'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD INDEX `idx_registration_source_status` (`source_table`, `source_id`, `registration_status`)'
  )
);
PREPARE stmt_create_registration_source_status_index FROM @create_registration_source_status_index;
EXECUTE stmt_create_registration_source_status_index;
DEALLOCATE PREPARE stmt_create_registration_source_status_index;

SET @create_travel_source_index = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'travel_confirmation'
        AND index_name = 'idx_travel_source'
    ),
    'SELECT 1',
    'ALTER TABLE `travel_confirmation` ADD INDEX `idx_travel_source` (`source_table`, `source_id`)'
  )
);
PREPARE stmt_create_travel_source_index FROM @create_travel_source_index;
EXECUTE stmt_create_travel_source_index;
DEALLOCATE PREPARE stmt_create_travel_source_index;

SET @create_refund_source_index = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'refund_request'
        AND index_name = 'idx_refund_source'
    ),
    'SELECT 1',
    'ALTER TABLE `refund_request` ADD INDEX `idx_refund_source` (`source_table`, `source_id`)'
  )
);
PREPARE stmt_create_refund_source_index FROM @create_refund_source_index;
EXECUTE stmt_create_refund_source_index;
DEALLOCATE PREPARE stmt_create_refund_source_index;

UPDATE `registration_information`
SET `registration_status` = '已报名'
WHERE `registration_status` IS NULL OR TRIM(`registration_status`) = '';

UPDATE `registration_information`
SET `registration_status` = '已报名'
WHERE `registration_status` IN ('退款申请', '申请退款', '退款处理');

UPDATE `registration_information`
SET `confirm_time` = IFNULL(`confirm_time`, IFNULL(`create_time`, NOW()))
WHERE `registration_status` = '已报名';

UPDATE `registration_information`
SET `travel_confirmation_limit_times` = '1'
WHERE `travel_confirmation_limit_times` IS NULL OR TRIM(`travel_confirmation_limit_times`) = '';

UPDATE `registration_information`
SET `refund_request_limit_times` = '1'
WHERE `refund_request_limit_times` IS NULL OR TRIM(`refund_request_limit_times`) = '';

UPDATE `registration_information`
SET `number_of_registrations` = 1
WHERE `number_of_registrations` IS NULL OR `number_of_registrations` < 1;

UPDATE `travel_confirmation` tc
JOIN `registration_information` ri ON tc.`order_number` = ri.`order_number`
SET tc.`source_table` = 'registration_information',
    tc.`source_id` = ri.`registration_information_id`,
    tc.`source_user_id` = ri.`enrolled_user`,
    tc.`host_user` = ri.`host_user`,
    tc.`enrolled_user` = ri.`enrolled_user`
WHERE (tc.`source_id` IS NULL OR tc.`source_id` = 0)
  AND ri.`registration_information_id` IS NOT NULL;

UPDATE `refund_request` rr
JOIN `registration_information` ri ON rr.`order_number` = ri.`order_number`
SET rr.`source_table` = 'registration_information',
    rr.`source_id` = ri.`registration_information_id`,
    rr.`source_user_id` = ri.`enrolled_user`,
    rr.`host_user` = ri.`host_user`,
    rr.`enrolled_user` = ri.`enrolled_user`
WHERE (rr.`source_id` IS NULL OR rr.`source_id` = 0)
  AND ri.`registration_information_id` IS NOT NULL;

UPDATE `travel_confirmation` tc
JOIN `registration_information` ri ON tc.`source_table` = 'registration_information' AND tc.`source_id` = ri.`registration_information_id`
SET tc.`number_of_attendees` = LEAST(GREATEST(IFNULL(tc.`number_of_attendees`, 1), 1), IFNULL(ri.`number_of_registrations`, 1))
WHERE tc.`number_of_attendees` IS NULL
   OR tc.`number_of_attendees` < 1
   OR tc.`number_of_attendees` > IFNULL(ri.`number_of_registrations`, 1);

SET @add_registration_people_check = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.table_constraints
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND constraint_name = 'chk_registration_people_min'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD CONSTRAINT `chk_registration_people_min` CHECK (`number_of_registrations` >= 1)'
  )
);
PREPARE stmt_add_registration_people_check FROM @add_registration_people_check;
EXECUTE stmt_add_registration_people_check;
DEALLOCATE PREPARE stmt_add_registration_people_check;

SET @add_registration_people_integer_check = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.table_constraints
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND constraint_name = 'chk_registration_people_integer'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD CONSTRAINT `chk_registration_people_integer` CHECK (`number_of_registrations` = FLOOR(`number_of_registrations`))'
  )
);
PREPARE stmt_add_registration_people_integer_check FROM @add_registration_people_integer_check;
EXECUTE stmt_add_registration_people_integer_check;
DEALLOCATE PREPARE stmt_add_registration_people_integer_check;

SET @add_travel_attendee_check = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.table_constraints
      WHERE table_schema = DATABASE()
        AND table_name = 'travel_confirmation'
        AND constraint_name = 'chk_travel_attendee_min'
    ),
    'SELECT 1',
    'ALTER TABLE `travel_confirmation` ADD CONSTRAINT `chk_travel_attendee_min` CHECK (`number_of_attendees` >= 1)'
  )
);
PREPARE stmt_add_travel_attendee_check FROM @add_travel_attendee_check;
EXECUTE stmt_add_travel_attendee_check;
DEALLOCATE PREPARE stmt_add_travel_attendee_check;

SET @add_travel_attendee_integer_check = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.table_constraints
      WHERE table_schema = DATABASE()
        AND table_name = 'travel_confirmation'
        AND constraint_name = 'chk_travel_attendee_integer'
    ),
    'SELECT 1',
    'ALTER TABLE `travel_confirmation` ADD CONSTRAINT `chk_travel_attendee_integer` CHECK (`number_of_attendees` = FLOOR(`number_of_attendees`))'
  )
);
PREPARE stmt_add_travel_attendee_integer_check FROM @add_travel_attendee_integer_check;
EXECUTE stmt_add_travel_attendee_integer_check;
DEALLOCATE PREPARE stmt_add_travel_attendee_integer_check;

INSERT IGNORE INTO `auth` (`auth_id`,`user_group`,`mod_name`,`table_name`,`page_title`,`path`,`parent`,`parent_sort`,`position`,`mode`,`add`,`del`,`set`,`get`,`field_add`,`field_set`,`field_get`,`table_nav_name`,`table_nav`,`option`,`create_time`,`update_time`)
VALUES ('173','管理员','用户行为追踪','user_track_log','用户行为追踪','/user_track_log/table','','0','','_blank','1','0','0','0','','','','','0','{}',NOW(),NOW());

UPDATE `auth`
SET `add` = 1, `get` = 1, `update_time` = NOW()
WHERE `user_group` = '普通用户'
  AND `path` IN ('/travel_confirmation/table', '/travel_confirmation/view', '/refund_request/table', '/refund_request/view');

UPDATE `auth`
SET `add` = 0, `set` = 0, `get` = 0, `del` = 0, `update_time` = NOW()
WHERE `user_group` = '主办用户'
  AND `path` LIKE '/data_statistics/%';

UPDATE `auth`
SET `option` = JSON_SET(COALESCE(NULLIF(`option`, ''), '{}'), '$.examine', true),
    `get` = 1,
    `set` = 1,
    `update_time` = NOW()
WHERE `user_group` IN ('管理员', '主办用户')
  AND `path` IN ('/registration_information/table', '/travel_confirmation/table', '/refund_request/table');
