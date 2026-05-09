USE `project_db`;

SET @status_confirmed = CONVERT(0xe5b7b2e68aa5e5908d USING utf8mb4);
SET @status_waitlist = CONVERT(0xe58099e8a1a5e4b8ad USING utf8mb4);
SET @examine_approved = CONVERT(0xe5b7b2e9809ae8bf87 USING utf8mb4);
SET @examine_pending = CONVERT(0xe69caae5aea1e6a0b8 USING utf8mb4);
SET @pay_paid = CONVERT(0xe5b7b2e694afe4bb98 USING utf8mb4);
SET @pay_unpaid = CONVERT(0xe69caae694afe4bb98 USING utf8mb4);

SET @add_registration_status_column = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND column_name = 'registration_status'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD COLUMN `registration_status` varchar(32) DEFAULT NULL'
  )
);
PREPARE stmt_add_registration_status_column FROM @add_registration_status_column;
EXECUTE stmt_add_registration_status_column;
DEALLOCATE PREPARE stmt_add_registration_status_column;

SET @add_waitlist_no_column = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND column_name = 'waitlist_no'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD COLUMN `waitlist_no` int DEFAULT NULL'
  )
);
PREPARE stmt_add_waitlist_no_column FROM @add_waitlist_no_column;
EXECUTE stmt_add_waitlist_no_column;
DEALLOCATE PREPARE stmt_add_waitlist_no_column;

SET @add_waitlist_time_column = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND column_name = 'waitlist_time'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD COLUMN `waitlist_time` datetime DEFAULT NULL'
  )
);
PREPARE stmt_add_waitlist_time_column FROM @add_waitlist_time_column;
EXECUTE stmt_add_waitlist_time_column;
DEALLOCATE PREPARE stmt_add_waitlist_time_column;

SET @add_confirm_time_column = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND column_name = 'confirm_time'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD COLUMN `confirm_time` datetime DEFAULT NULL'
  )
);
PREPARE stmt_add_confirm_time_column FROM @add_confirm_time_column;
EXECUTE stmt_add_confirm_time_column;
DEALLOCATE PREPARE stmt_add_confirm_time_column;

SET @add_cancel_time_column = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'registration_information'
        AND column_name = 'cancel_time'
    ),
    'SELECT 1',
    'ALTER TABLE `registration_information` ADD COLUMN `cancel_time` datetime DEFAULT NULL'
  )
);
PREPARE stmt_add_cancel_time_column FROM @add_cancel_time_column;
EXECUTE stmt_add_cancel_time_column;
DEALLOCATE PREPARE stmt_add_cancel_time_column;

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

DELETE FROM `travel_confirmation`
WHERE `source_table` = 'registration_information'
  AND `source_id` IN (
    SELECT rid
    FROM (
      SELECT `registration_information_id` AS rid
      FROM `registration_information`
      WHERE `order_number` LIKE 'WAITDEMO%'
    ) AS waitlist_demo_registration_ids
  );

DELETE FROM `refund_request`
WHERE `source_table` = 'registration_information'
  AND `source_id` IN (
    SELECT rid
    FROM (
      SELECT `registration_information_id` AS rid
      FROM `registration_information`
      WHERE `order_number` LIKE 'WAITDEMO%'
    ) AS waitlist_demo_refund_ids
  );

DELETE FROM `message_inform`
WHERE `type` = 'waitlist_demo';

DELETE FROM `registration_information`
WHERE `order_number` LIKE 'WAITDEMO%';

UPDATE `booth_information`
SET `host_user` = 5,
    `registration_information_limit_times` = 1
WHERE `booth_information_id` = 12;

INSERT INTO `registration_information` (
  `order_number`,
  `booth_number`,
  `exhibitionconvention_number`,
  `exhibition_theme`,
  `host_user`,
  `booth_name`,
  `booth_type`,
  `booth_prices`,
  `enrolled_user`,
  `user_name`,
  `users_mobile_phone`,
  `number_of_registrations`,
  `enterprise_qualifications`,
  `registration_notes`,
  `site_plan`,
  `exhibitor_documents`,
  `examine_state`,
  `examine_reply`,
  `pay_state`,
  `pay_type`,
  `travel_confirmation_limit_times`,
  `refund_request_limit_times`,
  `extra`,
  `source_table`,
  `source_id`,
  `source_user_id`,
  `create_by`,
  `registration_status`,
  `waitlist_no`,
  `waitlist_time`,
  `confirm_time`,
  `cancel_time`,
  `create_time`,
  `update_time`
) VALUES
(
  'WAITDEMO001',
  'A01',
  'EXPO2024-001',
  'Future Tech Living Expo',
  5,
  'Innovation Booth',
  'Standard Booth',
  12.00,
  2,
  'Demo Confirmed User',
  '13700000001',
  1,
  '',
  'waitlist demo - confirmed seat',
  '',
  '',
  @examine_approved,
  'waitlist demo init',
  @pay_paid,
  'alipay',
  1,
  1,
  '',
  'booth_information',
  12,
  2,
  2,
  @status_confirmed,
  NULL,
  NULL,
  '2026-05-08 20:00:00',
  NULL,
  '2026-05-08 20:00:00',
  '2026-05-08 20:00:00'
),
(
  'WAITDEMO002',
  'A01',
  'EXPO2024-001',
  'Future Tech Living Expo',
  5,
  'Innovation Booth',
  'Standard Booth',
  12.00,
  3,
  'Demo Waitlist User 1',
  '13700000002',
  1,
  '',
  'waitlist demo - queue no 1',
  '',
  '',
  @examine_pending,
  '',
  @pay_unpaid,
  '',
  1,
  1,
  '',
  'booth_information',
  12,
  3,
  3,
  @status_waitlist,
  1,
  '2026-05-08 20:10:00',
  NULL,
  NULL,
  '2026-05-08 20:10:00',
  '2026-05-08 20:10:00'
),
(
  'WAITDEMO003',
  'A01',
  'EXPO2024-001',
  'Future Tech Living Expo',
  5,
  'Innovation Booth',
  'Standard Booth',
  12.00,
  4,
  'Demo Waitlist User 2',
  '13700000003',
  1,
  '',
  'waitlist demo - queue no 2',
  '',
  '',
  @examine_pending,
  '',
  @pay_unpaid,
  '',
  1,
  1,
  '',
  'booth_information',
  12,
  4,
  4,
  @status_waitlist,
  2,
  '2026-05-08 20:20:00',
  NULL,
  NULL,
  '2026-05-08 20:20:00',
  '2026-05-08 20:20:00'
);

INSERT INTO `message_inform` (`user_id`, `title`, `state`, `type`, `content`, `create_time`, `update_time`) VALUES
(2, 'Waitlist Demo', 'unread', 'waitlist_demo', 'You currently hold the confirmed seat for booth A01.', NOW(), NOW()),
(3, 'Waitlist Demo', 'unread', 'waitlist_demo', 'You are currently waitlist no. 1 for booth A01.', NOW(), NOW()),
(4, 'Waitlist Demo', 'unread', 'waitlist_demo', 'You are currently waitlist no. 2 for booth A01.', NOW(), NOW()),
(5, 'Waitlist Demo', 'unread', 'waitlist_demo', 'Host view can now see one confirmed seat and two waitlist entries for booth A01.', NOW(), NOW());

SELECT `booth_information_id`, `booth_number`, `booth_name`, `host_user`, `registration_information_limit_times`
FROM `booth_information`
WHERE `booth_information_id` = 12;

SELECT
  `registration_information_id`,
  `order_number`,
  `enrolled_user`,
  `user_name`,
  `registration_status`,
  `waitlist_no`,
  `pay_state`,
  `examine_state`,
  `source_table`,
  `source_id`
FROM `registration_information`
WHERE `order_number` LIKE 'WAITDEMO%'
ORDER BY
  CASE
    WHEN `registration_status` = @status_confirmed THEN 1
    WHEN `registration_status` = @status_waitlist THEN 2
    ELSE 3
  END,
  `waitlist_no` ASC,
  `registration_information_id` ASC;
