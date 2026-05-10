CREATE DATABASE IF NOT EXISTS project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `project_db`;

CREATE TABLE IF NOT EXISTS `user_track_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_name` varchar(50) NOT NULL,
  `page` varchar(500) DEFAULT NULL,
  `data_json` longtext,
  `user_id` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_track_log_user_id` (`user_id`),
  KEY `idx_user_track_log_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `registration_information`
  ADD COLUMN IF NOT EXISTS `registration_status` varchar(32) DEFAULT NULL COMMENT '报名状态',
  ADD COLUMN IF NOT EXISTS `waitlist_no` int DEFAULT NULL COMMENT '候补序号',
  ADD COLUMN IF NOT EXISTS `waitlist_time` datetime DEFAULT NULL COMMENT '候补时间',
  ADD COLUMN IF NOT EXISTS `confirm_time` datetime DEFAULT NULL COMMENT '确认时间',
  ADD COLUMN IF NOT EXISTS `cancel_time` datetime DEFAULT NULL COMMENT '取消时间';

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

UPDATE `registration_information`
SET `registration_status` = '已报名'
WHERE `registration_status` IS NULL OR TRIM(`registration_status`) = '';

UPDATE `registration_information`
SET `confirm_time` = IFNULL(`confirm_time`, IFNULL(`create_time`, NOW()))
WHERE `registration_status` = '已报名';

UPDATE `registration_information`
SET `travel_confirmation_limit_times` = '1'
WHERE `travel_confirmation_limit_times` IS NULL OR TRIM(`travel_confirmation_limit_times`) = '';

UPDATE `registration_information`
SET `refund_request_limit_times` = '1'
WHERE `refund_request_limit_times` IS NULL OR TRIM(`refund_request_limit_times`) = '';
