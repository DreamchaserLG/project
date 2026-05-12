CREATE DATABASE IF NOT EXISTS project_db CHARACTER SET utf8;
USE `project_db`;
DROP TABLE IF EXISTS `slides`;
CREATE TABLE `slides` (
  `slides_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '标题',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '内容',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '链接',
  `img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '轮播图',
  `hits` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击量',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`slides_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='轮播图';
DROP TABLE IF EXISTS `auth`;
CREATE TABLE `auth` (
  `auth_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '授权ID',
  `user_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户组',
  `mod_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '模块名',
  `table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '表名',
  `page_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '页面标题',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '路由路径',
  `parent` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '父级菜单',
  `parent_sort` int(10) NOT NULL DEFAULT '0' COMMENT '父级菜单排序',
  `position` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '位置',
  `mode` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '_blank' COMMENT '跳转方式',
  `add` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否可增加',
  `del` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否可删除',
  `set` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否可修改',
  `get` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否可查看',
  `field_add` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '添加字段',
  `field_set` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '修改字段',
  `field_get` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '查询字段',
  `table_nav_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '跨表导航名称',
  `table_nav` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '跨表导航',
  `option` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '配置',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`auth_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户权限管理';
DROP TABLE IF EXISTS `upload`;
CREATE TABLE `upload` (
  `upload_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '上传ID',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件名',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '访问路径',
  `file` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件路径',
  `display` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '显示顺序',
  `father_id` int(11) DEFAULT '0' COMMENT '父级ID',
  `dir` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件夹',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件类型',
  PRIMARY KEY (`upload_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件上传';
insert into `upload` values ('1','movie.mp4','/upload/movie.mp4','',null,'0',null,'video');
DROP TABLE IF EXISTS `message_inform`;
CREATE TABLE `message_inform` (
  `message_inform_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知人ID',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `state` varchar(255) DEFAULT NULL COMMENT '状态',
  `type` varchar(64) DEFAULT NULL COMMENT '分类',
  `content` varchar(255) DEFAULT NULL COMMENT '内容',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`message_inform_id`) USING BTREE,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='通知记录';
DROP TABLE IF EXISTS `nav`;
CREATE TABLE `nav` (
  `nav_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'navigation ID',
  `name` varchar(128) DEFAULT NULL COMMENT 'navigation name',
  `location` varchar(32) DEFAULT NULL COMMENT 'location',
  `target` varchar(32) DEFAULT NULL COMMENT 'target',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `father_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'parent ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`nav_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='navigation';
DROP TABLE IF EXISTS `releasing_notices`;
CREATE TABLE `releasing_notices` (
  `notices_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'notice ID',
  `title` varchar(255) DEFAULT NULL COMMENT 'title',
  `type` varchar(128) DEFAULT NULL COMMENT 'type',
  `content` text COMMENT 'content',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`notices_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='released notices';
DROP TABLE IF EXISTS `sensitive_vocabulary`;
CREATE TABLE `sensitive_vocabulary` (
  `sensitive_vocabulary_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'sensitive vocabulary ID',
  `sensitive_vocabulary` varchar(255) NOT NULL COMMENT 'sensitive word',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`sensitive_vocabulary_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='sensitive vocabulary';
DROP TABLE IF EXISTS `subject_user_answer`;
CREATE TABLE `subject_user_answer` (
  `subject_user_answer_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'answer ID',
  `exam_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'exam ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'user ID',
  `nickname` varchar(128) DEFAULT NULL COMMENT 'nickname',
  `score` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'score',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`subject_user_answer_id`) USING BTREE,
  KEY `idx_subject_user_answer_exam` (`exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='subject user answer';
DROP TABLE IF EXISTS `customer_chat_group`;
CREATE TABLE `customer_chat_group` (
  `customer_chat_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'chat group ID',
  `member` text COMMENT 'member json',
  `unread_count` int(11) NOT NULL DEFAULT '0' COMMENT 'unread count',
  `last_read_time` datetime DEFAULT NULL COMMENT 'last read time',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`customer_chat_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='customer chat group';
DROP TABLE IF EXISTS `customer_chat_log`;
CREATE TABLE `customer_chat_log` (
  `customer_chat_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'chat log ID',
  `customer_chat_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'chat group ID',
  `content` longtext COMMENT 'chat content',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`customer_chat_log_id`) USING BTREE,
  UNIQUE KEY `uk_customer_chat_log_chat` (`customer_chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='customer chat log';
DROP TABLE IF EXISTS `user_group`;
CREATE TABLE `user_group` (
  `group_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组ID',
  `display` smallint(4) unsigned NOT NULL DEFAULT '100' COMMENT '显示顺序',
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '描述',
  `source_table` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源表',
  `source_field` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源字段',
  `source_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源ID',
  `register` smallint(1) unsigned DEFAULT '0' COMMENT '注册位置',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户组';
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `article_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `title` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '文章分类',
  `hits` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `praise_len` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源地址',
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '正文',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面图',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '文章描述',
  PRIMARY KEY (`article_id`,`title`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文章';
DROP TABLE IF EXISTS `access_token`;
CREATE TABLE `access_token` (
  `token_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '临时访问牌ID',
  `token` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '临时访问牌',
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '信息',
  `maxage` int(2) NOT NULL DEFAULT '2' COMMENT '最大寿命：默认2小时',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户编号',
  PRIMARY KEY (`token_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='登陆访问时长';
DROP TABLE IF EXISTS `code_token`;
CREATE TABLE `code_token` (
  `code_token_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '验证码ID',
  `token` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '令牌',
  `code` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '验证码',
  `expire_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '失效时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`code_token_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='验证码';
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect` (
  `collect_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收藏人ID',
  `source_table` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源表',
  `source_field` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源字段',
  `source_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '标题',
  `img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '封面',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`collect_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='收藏';
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `notice_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(125) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '正文',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='公告';
insert into `notice` values ('1','系统维护通知','<p>网站升级通知</p><p>尊敬的客户，为了提供更好的用户体验，我们将于本周三凌晨1:00-5:00进行系统维护升级，期间可能出现短暂服务中断。建议您提前保存操作数据，感谢您的理解与支持！</p>','2026-04-16 21:03:31','2026-04-16 21:03:31');
insert into `notice` values ('2','新功能上线','<p>搜索功能已优化升级！现已正式开放使用，支持关键词搜索，快去体验检索服务吧~</p>','2026-04-16 21:03:31','2026-04-16 21:03:31');
insert into `notice` values ('3','客服时间调整','<p>人工客服服务时间已延长为每日8:00-22:00（含节假日），智能客服24小时在线，随时为您解答问题。</p>','2026-04-16 21:03:31','2026-04-16 21:03:31');
insert into `notice` values ('4','规范提示','<p>请遵守《用户行为守则》：禁止发布广告、虚假信息及不当内容。共同维护友善的网络环境，违规账号将受到限制。</p>','2026-04-16 21:03:31','2026-04-16 21:03:31');
DROP TABLE IF EXISTS `article_type`;
CREATE TABLE `article_type` (
  `type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `display` smallint(4) unsigned NOT NULL DEFAULT '100' COMMENT '显示顺序',
  `name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `father_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `icon` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '分类图标',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外链地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文章分类';
DROP TABLE IF EXISTS `praise`;
CREATE TABLE `praise` (
  `praise_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '点赞人',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `source_table` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源表',
  `source_field` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源字段',
  `source_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源ID',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '点赞状态:1为点赞，0已取消',
  `img` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`praise_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='点赞';
DROP TABLE IF EXISTS `hits`;
CREATE TABLE `hits` (
  `hits_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '点赞人',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `source_table` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源表',
  `source_field` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源字段',
  `source_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源ID',
  PRIMARY KEY (`hits_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户点击';
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论人ID',
  `reply_to_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '回复评论ID',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '内容',
  `nickname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '头像地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `source_table` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源表',
  `source_field` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '来源字段',
  `source_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源ID',
  `hidden` tinyint(4) DEFAULT '0' COMMENT '是否隐藏',
  `sticky` tinyint(4) DEFAULT '0' COMMENT '是否置顶',
  PRIMARY KEY (`comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评论';
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `state` smallint(1) unsigned NOT NULL DEFAULT '1' COMMENT '账户状态：(1可用|2异常|3已冻结|4已注销)',
  `user_group` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '所在用户组',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '上次登录时间',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '手机号码',
  `phone_state` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '手机认证：(0未认证|1审核中|2已认证)',
  `username` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '昵称',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '邮箱',
  `email_state` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '邮箱认证：(0未认证|1审核中|2已认证)',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '头像地址',
  `open_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '针对获取用户信息字段',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `vip_level` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '会员等级',
  `vip_discount` double(10,2) DEFAULT '0.00' COMMENT '会员折扣',
  `integral` int(11) DEFAULT '0' COMMENT '积分',
  `balance` double(10,2) DEFAULT '0.00' COMMENT '余额',
  `ip` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'IPv4/IPv6地址',
  `device_hash` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备指纹',
  `emergency_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '紧急联系人',
  `emergency_mobile` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '紧急联系电话',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户账户';
insert into `user` values ('1','1','管理员','2025-10-09 09:20:03.0',null,'0','admin','admin','bfd59291e825b5f2bbf1eb76569f8fe7','','0','/api/upload/default_avatar.jpg',null,'2026-04-16 21:03:31',null,'0.0','0','0.0',null,null,null,null);
ALTER TABLE `user` DROP COLUMN balance;
ALTER TABLE `user` DROP COLUMN integral;
ALTER TABLE `user` DROP COLUMN vip_level;
ALTER TABLE `user` DROP COLUMN vip_discount;
ALTER TABLE `user` DROP COLUMN ip;
ALTER TABLE `user` DROP COLUMN device_hash;
ALTER TABLE `user` DROP COLUMN emergency_name;
ALTER TABLE `user` DROP COLUMN emergency_mobile;
UPDATE `user` SET password = 'abdaf117e4e6197ac5f65805d40f01b8';
UPDATE user SET avatar = '/api/upload/default_avatar.jpg';
DROP TABLE IF EXISTS `regular_user`;
CREATE TABLE `regular_user`(regular_user_id int(11) NOT NULL AUTO_INCREMENT COMMENT '普通用户ID',
`user_name` varchar(64) comment '用户姓名',
`users_mobile_phone` varchar(16) comment '用户手机',
`examine_state` varchar(16) DEFAULT '已通过' NOT NULL comment '审核状态',
`user_id` int(11) DEFAULT '0' NOT NULL comment '用户ID',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (regular_user_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '普通用户';
insert into `regular_user` values (1,'赵磊','13700137000','已通过',2,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('普通用户','yonghu1','yonghu1','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');
insert into `regular_user` values (2,'孙悦','15500155000','已通过',3,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('普通用户','yonghu2','yonghu2','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');
insert into `regular_user` values (3,'王芳','13900139000','已通过',4,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('普通用户','yonghu3','yonghu3','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');

DROP TABLE IF EXISTS `host_user`;
CREATE TABLE `host_user`(host_user_id int(11) NOT NULL AUTO_INCREMENT COMMENT '主办用户ID',
`company_name` varchar(64) comment '企业名称',
`company_phone` varchar(16) comment '企业电话',
`qualification_certificate` varchar(255) comment '资质证明',
`examine_state` varchar(16) DEFAULT '未审核' NOT NULL comment '审核状态',
`user_id` int(11) DEFAULT '0' NOT NULL comment '用户ID',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (host_user_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '主办用户';
insert into `host_user` values (1,'金鼎资本','146-21474900','','已通过',5,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('主办用户','yonghu4','yonghu4','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');
insert into `host_user` values (2,'星海科技','9014-86525111','','已通过',6,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('主办用户','yonghu5','yonghu5','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');
insert into `host_user` values (3,'蓝海战略','2839-08747556','','已通过',7,'2026-04-16 21:03:31',1,'2026-04-16 21:03:31');
insert into user(user_group,username,nickname,password,avatar) values ('主办用户','yonghu6','yonghu6','abdaf117e4e6197ac5f65805d40f01b8','/api/upload/default_avatar.jpg');

DROP TABLE IF EXISTS `exhibition_information`;
CREATE TABLE `exhibition_information`(exhibition_information_id int(11) NOT NULL AUTO_INCREMENT COMMENT '会展信息ID',
`exhibitionconvention_number` varchar(64) comment '会展编号',
`exhibition_theme` varchar(64) comment '会展主题',
`exhibition_and_convention_types` varchar(64) comment '会展类型',
`event_time` varchar(64) comment '举办时间',
`event_venue_name` varchar(64) comment '举办地点',
`exhibition_status` varchar(64) comment '会展状态',
`exhibition_poster` varchar(255) comment '会展海报',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`introduction_document` varchar(255) comment '介绍文档',
`fee_standards` text comment '费用标准',
`schedule_t` longtext comment '日程安排',
`hits` int(11) DEFAULT 0 NOT NULL comment '点击数',
`praise_len` int(11) DEFAULT 0 NOT NULL comment '点赞数',
`collect_len` int(11) DEFAULT 0 NOT NULL comment '收藏数',
`comment_len` int(11) DEFAULT 0 NOT NULL comment '评论数',
`examine_state` varchar(16) DEFAULT '未审核' NOT NULL comment '审核状态',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (exhibition_information_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '会展信息';
insert into `exhibition_information` values (1,'CONF-2024-A01','绿色地球环保展','专业会议',' 2025-02-14 10:20','广州琶洲展馆','会展状态1','/api/upload/1872560521400549377.jpg',0,'','费用标准1','此处可上传文字、图片、视频、超链接等内容区1',452,427,976,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (2,'SHOW-24-B002','数字艺术创意展','公益慈善展',' 2024-11-11 13:15','青岛国际会展中心','会展状态2','/api/upload/1872560438676291584.jpg',0,'','费用标准2','此处可上传文字、图片、视频、超链接等内容区2',61,332,836,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (3,'EXPO2024-004','国际动漫游戏展','艺术展览',' 2024-08-22 14:30','杭州国际博览中心','会展状态3','/api/upload/1872560578883485697.jpg',0,'','费用标准3','此处可上传文字、图片、视频、超链接等内容区3',522,453,978,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (4,'SHOW-24-B003','世界旅游文化展','科技博览会',' 2025-06-12 19:30','深圳会展中心','会展状态4','/api/upload/1872561183685345281.jpg',0,'','费用标准4','此处可上传文字、图片、视频、超链接等内容区4',120,420,19,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (5,'CONF-2024-A03','时尚设计潮流展','新品发布会',' 2025-04-25 18:00','台北南港展览馆','会展状态5','/api/upload/1872560483886694400.jpg',0,'','费用标准5','此处可上传文字、图片、视频、超链接等内容区5',159,374,615,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (6,'EXPO2024-005','传统文化复兴展','文化节庆',' 2025-01-20 15:30','成都世纪城新国际会展中心','会展状态6','/api/upload/1872560415003639808.jpg',0,'','费用标准6','此处可上传文字、图片、视频、超链接等内容区6',398,412,383,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (7,'CONF-2024-A02','智慧城市创新展','行业峰会',' 2025-05-30 14:00','厦门国际会展中心','会展状态7','/api/upload/1872560464651616256.jpg',0,'','费用标准7','此处可上传文字、图片、视频、超链接等内容区7',345,894,42,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (8,'EXPO2024-003','国际教育装备展','投资洽谈会',' 2024-10-18 16:00','武汉国际博览中心','会展状态8','/api/upload/1872560504107433985.jpg',0,'','费用标准8','此处可上传文字、图片、视频、超链接等内容区8',323,274,422,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (9,'EXPO2024-006','新能源汽车科技展','消费展览',' 2025-03-08 08:45','南京国际博览中心','会展状态9','/api/upload/1872561202530353152.jpg',0,'','费用标准9','此处可上传文字、图片、视频、超链接等内容区9',334,697,483,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (10,'SHOW-24-B001','健康生活博览会','教育展览',' 2024-12-06 11:45','中国国际展览中心（北京）','会展状态10','/api/upload/1872560538781745153.jpg',0,'','费用标准10','此处可上传文字、图片、视频、超链接等内容区10',639,100,586,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (11,'EXPO2024-002','全球美食文化节','招聘会',' 2024-09-05 09:00','香港会议展览中心','会展状态11','/api/upload/1872560848992468993.jpg',0,'','费用标准11','此处可上传文字、图片、视频、超链接等内容区11',605,637,433,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `exhibition_information` values (12,'EXPO2024-001','未来科技生活展','贸易展览','2024-07-15 10:00','国家会展中心（上海）','会展状态12','/api/upload/1872560391813332992.jpg',0,'','费用标准12','此处可上传文字、图片、视频、超链接等内容区12',542,645,273,0,'已通过','2026-04-16 21:03:32',1,'2026-04-16 21:03:32');

DROP TABLE IF EXISTS `booth_information`;
CREATE TABLE `booth_information`(booth_information_id int(11) NOT NULL AUTO_INCREMENT COMMENT '展位信息ID',
`booth_number` varchar(64) NOT NULL UNIQUE comment '展位编号',
`exhibitionconvention_number` varchar(64) comment '会展编号',
`exhibition_theme` varchar(64) comment '会展主题',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`booth_name` varchar(64) comment '展位名称',
`booth_type` varchar(64) comment '展位类型',
`booth_location` varchar(64) comment '展位位置',
`booth_prices` double(8,2) DEFAULT 0 comment '展位价格',
`booth_specifications` varchar(64) comment '展位规格',
`booth_images` varchar(255) comment '展位图片',
`booth_specificss` longtext comment '展位详情',
`hits` int(11) DEFAULT 0 NOT NULL comment '点击数',
`praise_len` int(11) DEFAULT 0 NOT NULL comment '点赞数',
`collect_len` int(11) DEFAULT 0 NOT NULL comment '收藏数',
`comment_len` int(11) DEFAULT 0 NOT NULL comment '评论数',
`examine_state` varchar(16) DEFAULT '未审核' NOT NULL comment '审核状态',
`registration_information_limit_times` int(8) DEFAULT 0 NOT NULL comment '报名限制次数',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (booth_information_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '展位信息';
insert into `booth_information` values (1,'C01','会展编号1','会展主题1',0,'行业灯塔','创意装置展位','C2',1,'5x5米特装空地','/api/upload/2039526773309308929.jpg','此处可上传文字、图片、视频、超链接等内容区1',892,233,490,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (2,'B01','会展编号2','会展主题2',0,'科技方舟','迷你展位','A2',2,'6x6米豪华岛型展位','/api/upload/2039526783413387265.jpg','此处可上传文字、图片、视频、超链接等内容区2',753,789,187,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (3,'A03','会展编号3','会展主题3',0,'合作桥梁','主题展馆','C3',3,'9x12米超大展示空间','/api/upload/2039526817383055361.jpg','此处可上传文字、图片、视频、超链接等内容区3',609,613,558,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (4,'A02','会展编号4','会展主题4',0,'专业领地','产品发布台','A3',4,'4x6米双开口展位','/api/upload/2039526686025842689.jpg','此处可上传文字、图片、视频、超链接等内容区4',29,138,906,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (5,'D03','会展编号5','会展主题5',0,'机遇之门','半岛型展位','D2',5,'6x8米主通道展位','/api/upload/2039526725255168000.jpg','此处可上传文字、图片、视频、超链接等内容区5',210,488,336,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (6,'D02','会展编号6','会展主题6',0,'梦想工坊','互动体验区','B3',6,'4x5米半岛型展位','/api/upload/2039526792351449089.jpg','此处可上传文字、图片、视频、超链接等内容区6',704,362,347,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (7,'D01','会展编号7','会展主题7',0,'智慧聚点','商务洽谈区','D1',7,'3x4米L型展位','/api/upload/2039526695886651392.jpg','此处可上传文字、图片、视频、超链接等内容区7',15,898,462,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (8,'C02','会展编号8','会展主题8',0,'灵感交汇','岛型展位','C1',8,'4x4米岛型展位','/api/upload/2039526705541939200.jpg','此处可上传文字、图片、视频、超链接等内容区8',780,922,176,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (9,'C03','会展编号9','会展主题9',0,'品牌舞台','角位展位','B1',9,'5x6米异型展位','/api/upload/2039526857212166145.jpg','此处可上传文字、图片、视频、超链接等内容区9',634,183,897,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (10,'B03','会展编号10','会展主题10',0,'未来视窗','特装展位','B2',10,'3x6米通道型展位','/api/upload/2039526716006727680.jpg','此处可上传文字、图片、视频、超链接等内容区10',516,597,700,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (11,'B02','会展编号11','会展主题11',0,'精英荟萃','双层展位','D3',11,'8x8米旗舰展位','/api/upload/2039526763897290753.jpg','此处可上传文字、图片、视频、超链接等内容区11',637,625,148,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');
insert into `booth_information` values (12,'A01','会展编号12','会展主题12',0,'创新前沿','标准展位','A1',12,'3x3米标准展位','/api/upload/2039526649506037761.jpg','此处可上传文字、图片、视频、超链接等内容区12',427,968,16,0,'已通过',0,'2026-04-16 21:03:32',1,'2026-04-16 21:03:32');

DROP TABLE IF EXISTS `registration_information`;
CREATE TABLE `registration_information`(registration_information_id int(11) NOT NULL AUTO_INCREMENT COMMENT '报名信息ID',
`order_number` varchar(64) comment '订单编号',
`booth_number` varchar(64) NOT NULL UNIQUE comment '展位编号',
`exhibitionconvention_number` varchar(64) comment '会展编号',
`exhibition_theme` varchar(64) comment '会展主题',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`booth_name` varchar(64) comment '展位名称',
`booth_type` varchar(64) comment '展位类型',
`booth_prices` double(8,2) DEFAULT 0 comment '展位价格',
`enrolled_user` int(11) DEFAULT 0 comment '报名用户',
`user_name` varchar(64) comment '用户姓名',
`users_mobile_phone` varchar(64) comment '用户手机',
`number_of_registrations` double(8,2) DEFAULT 0 comment '报名人数',
`enterprise_qualifications` varchar(255) comment '企业资质',
`registration_notes` text comment '报名备注',
`site_plan` varchar(255) comment '场地平面图',
`exhibitor_documents` varchar(255) comment '参展文件',
`examine_state` varchar(16) DEFAULT '未审核' NOT NULL comment '审核状态',
`examine_reply` varchar(255) DEFAULT '' comment '审核回复',
`pay_state` varchar(16) DEFAULT '未支付' NOT NULL comment '支付状态',
`pay_type` varchar(16) DEFAULT '' comment '支付类型: 微信、支付宝、网银',
`travel_confirmation_limit_times` int(8) DEFAULT 1 NOT NULL comment '行程确认限制次数',
`refund_request_limit_times` int(8) DEFAULT 1 NOT NULL comment '退款申请限制次数',
`escalate_state` varchar(16) DEFAULT '' comment '越级状态',
`escalate_reason` varchar(500) DEFAULT '' comment '越级原因',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (registration_information_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '报名信息';
insert into `registration_information` values (1,'ORD004','D02','CONF-2024-A01','全球美食文化节',0,'机遇之门','主题展馆',1,0,'周涛','15500155000',1,'','报名备注1','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (2,'ORD011','D01','EXPO2024-005','国际动漫游戏展',0,'合作桥梁','商务洽谈区',2,0,'张伟','13400134000',2,'','报名备注2','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (3,'ORD003','B02','EXPO2024-003','世界旅游文化展',0,'品牌舞台','特装展位',3,0,'刘洋','13500135000',3,'','报名备注3','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (4,'ORD007','D03','SHOW-24-B003','数字艺术创意展',0,'灵感交汇','角位展位',4,0,'黄俊','15900159000',4,'','报名备注4','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (5,'ORD006','B03','SHOW-24-B001','国际教育装备展',0,'行业灯塔','双层展位',5,0,'吴雪','15600156000',5,'','报名备注5','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (6,'ORD010','C03','EXPO2024-002','时尚设计潮流展',0,'未来视窗','岛型展位',6,0,'陈静','13900139000',6,'','报名备注6','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (7,'ORD008','A02','CONF-2024-A02','新能源汽车科技展',0,'专业领地','互动体验区',7,0,'徐强','15800158000',7,'','报名备注7','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (8,'ORD002','A03','SHOW-24-B002','智慧城市创新展',0,'梦想工坊','迷你展位',8,0,'孙悦','13600136000',8,'','报名备注8','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (9,'ORD005','C02','CONF-2024-A03','绿色地球环保展',0,'科技方舟','创意装置展位',9,0,'王芳','15700157000',9,'','报名备注9','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (10,'ORD012','C01','EXPO2024-006','健康生活博览会',0,'精英荟萃','产品发布台',10,0,'赵磊','18800188000',10,'','报名备注10','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (11,'ORD009','B01','EXPO2024-004','传统文化复兴展',0,'智慧聚点','半岛型展位',11,0,'林娜','13700137000',11,'','报名备注11','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `registration_information` values (12,'ORD001','A01','EXPO2024-001','未来科技生活展',0,'创新前沿','标准展位',12,0,'李明','13800138000',12,'','报名备注12','','','已通过','','未支付','支付宝',1,1,'','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');

DROP TABLE IF EXISTS `travel_confirmation`;
CREATE TABLE `travel_confirmation`(travel_confirmation_id int(11) NOT NULL AUTO_INCREMENT COMMENT '行程确认ID',
`order_number` varchar(64) comment '订单编号',
`booth_number` varchar(64) comment '展位编号',
`exhibitionconvention_number` varchar(64) comment '会展编号',
`exhibition_theme` varchar(64) comment '会展主题',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`enrolled_user` int(11) DEFAULT 0 comment '报名用户',
`user_name` varchar(64) comment '用户姓名',
`users_mobile_phone` varchar(64) comment '用户手机',
`confirm_time` datetime comment '确认时间',
`number_of_attendees` double(8,2) DEFAULT 0 comment '到场人数',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (travel_confirmation_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '行程确认';
insert into `travel_confirmation` values (1,'ORD007','B01','CONF-2024-A03','世界旅游文化展',0,0,'张伟','13900139000','2026-04-16 21:03:33',1,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (2,'ORD004','C03','CONF-2024-A02','数字艺术创意展',0,0,'陈静','15600156000','2026-04-16 21:03:33',2,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (3,'ORD011','C02','SHOW-24-B002','传统文化复兴展',0,0,'孙悦','13700137000','2026-04-16 21:03:33',3,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (4,'ORD008','A03','SHOW-24-B001','绿色地球环保展',0,0,'林娜','13600136000','2026-04-16 21:03:33',4,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (5,'ORD005','C01','EXPO2024-004','智慧城市创新展',0,0,'刘洋','15500155000','2026-04-16 21:03:33',5,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (6,'ORD010','D01','EXPO2024-003','国际教育装备展',0,0,'王芳','13400134000','2026-04-16 21:03:33',6,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (7,'ORD006','B02','EXPO2024-002','国际动漫游戏展',0,0,'赵磊','13500135000','2026-04-16 21:03:33',7,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (8,'ORD002','D03','EXPO2024-005','全球美食文化节',0,0,'周涛','15700157000','2026-04-16 21:03:33',8,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (9,'ORD003','A02','EXPO2024-006','新能源汽车科技展',0,0,'黄俊','15900159000','2026-04-16 21:03:33',9,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (10,'ORD012','D02','SHOW-24-B003','时尚设计潮流展',0,0,'徐强','18800188000','2026-04-16 21:03:33',10,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (11,'ORD009','B03','CONF-2024-A01','健康生活博览会',0,0,'吴雪','15800158000','2026-04-16 21:03:33',11,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `travel_confirmation` values (12,'ORD001','A01','EXPO2024-001','未来科技生活展',0,0,'李明','13800138000','2026-04-16 21:03:33',12,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');

DROP TABLE IF EXISTS `refund_request`;
CREATE TABLE `refund_request`(refund_request_id int(11) NOT NULL AUTO_INCREMENT COMMENT '退款申请ID',
`order_number` varchar(64) comment '订单编号',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`booth_prices` double(8,2) DEFAULT 0 comment '展位价格',
`enrolled_user` int(11) DEFAULT 0 comment '报名用户',
`user_name` varchar(64) comment '用户姓名',
`users_mobile_phone` varchar(64) comment '用户手机',
`application_time` datetime comment '申请时间',
`reason_for_application` text comment '申请理由',
`examine_state` varchar(16) DEFAULT '未审核' NOT NULL comment '审核状态',
`examine_reply` varchar(255) DEFAULT '' comment '审核回复',
`escalate_state` varchar(16) DEFAULT '' comment '申诉状态',
`escalate_reason` varchar(500) DEFAULT '' comment '申诉原因',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (refund_request_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '退款申请';
insert into `refund_request` values (1,'ORD007',0,1,0,'孙悦','13600136000','2026-04-16 21:03:33','申请理由1','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (2,'ORD011',0,2,0,'王芳','15700157000','2026-04-16 21:03:33','申请理由2','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (3,'ORD010',0,3,0,'林娜','13700137000','2026-04-16 21:03:33','申请理由3','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (4,'ORD008',0,4,0,'陈静','15800158000','2026-04-16 21:03:33','申请理由4','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (5,'ORD003',0,5,0,'黄俊','15600156000','2026-04-16 21:03:33','申请理由5','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (6,'ORD006',0,6,0,'吴雪','15900159000','2026-04-16 21:03:33','申请理由6','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (7,'ORD004',0,7,0,'赵磊','18800188000','2026-04-16 21:03:33','申请理由7','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (8,'ORD009',0,8,0,'徐强','15500155000','2026-04-16 21:03:33','申请理由8','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (9,'ORD002',0,9,0,'刘洋','13900139000','2026-04-16 21:03:33','申请理由9','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (10,'ORD012',0,10,0,'张伟','13500135000','2026-04-16 21:03:33','申请理由10','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (11,'ORD005',0,11,0,'周涛','13400134000','2026-04-16 21:03:33','申请理由11','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `refund_request` values (12,'ORD001',0,12,0,'李明','13800138000','2026-04-16 21:03:33','申请理由12','已通过','','','','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');

DROP TABLE IF EXISTS `message_notification`;
CREATE TABLE `message_notification`(message_notification_id int(11) NOT NULL AUTO_INCREMENT COMMENT '消息通知ID',
`notice_number` varchar(64) comment '通知编号',
`notice_title` varchar(64) comment '通知标题',
`notification_time` datetime comment '通知时间',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`regular_user` int(11) DEFAULT 0 comment '普通用户',
`notice_content` text comment '通知内容',
`mark_status` varchar(64) comment '标记状态',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (message_notification_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '消息通知';
insert into `message_notification` values (1,'NO20240520005','费用调整说明','2026-04-16 21:03:33',0,0,'通知内容1','标记状态1','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (2,'NO20240520010','活动邀请函','2026-04-16 21:03:33',0,0,'通知内容2','标记状态2','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (3,'NO20240520003','新功能上线通知','2026-04-16 21:03:33',0,0,'通知内容3','标记状态3','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (4,'NO20240520012','节假日安排通知','2026-04-16 21:03:33',0,0,'通知内容4','标记状态4','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (5,'NO20240520007','紧急安全补丁发布','2026-04-16 21:03:33',0,0,'通知内容5','标记状态5','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (6,'NO20240520011','重要更新提醒','2026-04-16 21:03:33',0,0,'通知内容6','标记状态6','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (7,'NO20240520002','操作指南变更','2026-04-16 21:03:33',0,0,'通知内容7','标记状态7','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (8,'NO20240520006','服务暂停公告','2026-04-16 21:03:33',0,0,'通知内容8','标记状态8','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (9,'NO20240520008','数据备份提醒','2026-04-16 21:03:33',0,0,'通知内容9','标记状态9','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (10,'NO20240520004','账户安全预警','2026-04-16 21:03:33',0,0,'通知内容10','标记状态10','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (11,'NO20240520009','版本更新日志','2026-04-16 21:03:33',0,0,'通知内容11','标记状态11','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `message_notification` values (12,'NO20240520001','系统维护通知','2026-04-16 21:03:33',0,0,'通知内容12','标记状态12','2026-04-16 21:03:33',1,'2026-04-16 21:03:33');

DROP TABLE IF EXISTS `exhibition_announcement`;
CREATE TABLE `exhibition_announcement`(exhibition_announcement_id int(11) NOT NULL AUTO_INCREMENT COMMENT '会展公告ID',
`announcement_title` varchar(64) comment '公告标题',
`announcement_type` varchar(64) comment '公告类型',
`exhibitionconvention_number` varchar(64) comment '会展编号',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`release_time` datetime comment '发布时间',
`announcement_image` varchar(255) comment '公告图片',
`announcement_vuser_ideo` varchar(255) comment '公告视频',
`announcement_content` longtext comment '公告内容',
`hits` int(11) DEFAULT 0 NOT NULL comment '点击数',
`praise_len` int(11) DEFAULT 0 NOT NULL comment '点赞数',
`collect_len` int(11) DEFAULT 0 NOT NULL comment '收藏数',
`comment_len` int(11) DEFAULT 0 NOT NULL comment '评论数',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (exhibition_announcement_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '会展公告';
insert into `exhibition_announcement` values (1,'全球绿色能源会展','公告类型1','EXPO2024-002',0,'2026-04-16 21:03:33','/api/upload/1878628406896099329.jpg','','此处可上传文字、图片、视频、超链接等内容区1',525,886,298,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (2,'中国国际健康产业博览会','公告类型2','CONF-2024-A01',0,'2026-04-16 21:03:33','/api/upload/1878628467348602881.jpg','','此处可上传文字、图片、视频、超链接等内容区2',376,119,811,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (3,'国际时尚生活消费品博览会','公告类型3','CONF-2024-A02',0,'2026-04-16 21:03:33','/api/upload/1878628479247843328.jpg','','此处可上传文字、图片、视频、超链接等内容区3',947,419,753,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (4,'未来出行与物流技术展','公告类型4','EXPO2024-003',0,'2026-04-16 21:03:33','/api/upload/1878628380727836673.jpg','','此处可上传文字、图片、视频、超链接等内容区4',358,726,429,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (5,'区块链技术与应用峰会','公告类型5','EXPO2024-005',0,'2026-04-16 21:03:33','/api/upload/1878628419307044865.jpg','','此处可上传文字、图片、视频、超链接等内容区5',482,330,423,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (6,'世界人工智能科技大会','公告类型6','SHOW-24-B001',0,'2026-04-16 21:03:33','/api/upload/1878628430526808065.jpg','','此处可上传文字、图片、视频、超链接等内容区6',186,885,190,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (7,'国际文化旅游产业博览会','公告类型7','SHOW-24-B003',0,'2026-04-16 21:03:33','/api/upload/1878628442086309888.jpg','','此处可上传文字、图片、视频、超链接等内容区7',279,138,254,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (8,'全球智能制造与工业互联网大会','公告类型8','EXPO2024-004',0,'2026-04-16 21:03:33','/api/upload/1878628393314942976.jpg','','此处可上传文字、图片、视频、超链接等内容区8',711,988,86,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (9,'亚太智慧城市展览会','公告类型9','EXPO2024-006',0,'2026-04-16 21:03:33','/api/upload/1878628357793382401.jpg','','此处可上传文字、图片、视频、超链接等内容区9',792,142,400,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (10,'国际教育装备与科技峰会','公告类型10','CONF-2024-A03',0,'2026-04-16 21:03:33','/api/upload/1878628456632156161.jpg','','此处可上传文字、图片、视频、超链接等内容区10',762,179,95,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (11,'国际创意设计展览会','公告类型11','SHOW-24-B002',0,'2026-04-16 21:03:33','/api/upload/1878628367985541121.jpg','','此处可上传文字、图片、视频、超链接等内容区11',10,51,288,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');
insert into `exhibition_announcement` values (12,'2024国际数字创新博览会','公告类型12','EXPO2024-001',0,'2026-04-16 21:03:33','/api/upload/1878628346712031232.jpg','','此处可上传文字、图片、视频、超链接等内容区12',465,237,608,0,'2026-04-16 21:03:33',1,'2026-04-16 21:03:33');

DROP TABLE IF EXISTS `data_statistics`;
CREATE TABLE `data_statistics`(data_statistics_id int(11) NOT NULL AUTO_INCREMENT COMMENT '数据统计ID',
`statistics_number` varchar(64) comment '统计编号',
`statistics_type` varchar(64) comment '统计类型',
`statistical_indicators` varchar(64) comment '统计指标',
`statistics_date` date comment '统计日期',
`statistical_results` double(8,2) DEFAULT 0 comment '统计结果',
`host_user` int(11) DEFAULT 0 comment '主办用户',
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`create_by` int(11) DEFAULT '1' NOT NULL comment '创建用户ID',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
PRIMARY KEY (data_statistics_id))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '数据统计';
insert into `data_statistics` values (1,'S007','成交额','国际参展商比例','2026-04-16',1,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (2,'S005','展览面积','观众满意度','2026-04-16',2,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (3,'S011','观众人数','现场成交额','2026-04-16',3,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (4,'S009','展位数量','观众数量','2026-04-16',4,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (5,'S010','媒体曝光量','意向成交额','2026-04-16',5,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (6,'S002','意向合作数','展期活动数量','2026-04-16',6,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (7,'S012','新技术展示项数','媒体报道数量','2026-04-16',7,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (8,'S003','国际参展商比例','展位数量','2026-04-16',8,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (9,'S008','同期活动场次','参展商满意度','2026-04-16',9,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (10,'S006','专业观众比例','展览面积','2026-04-16',10,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (11,'S004','观众满意度','专业观众比例','2026-04-16',11,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');
insert into `data_statistics` values (12,'S001','参展商数量','参展商数量','2026-04-16',12,0,'2026-04-16 21:03:34',1,'2026-04-16 21:03:34');

ALTER TABLE `refund_request` ADD COLUMN extra text comment '额外信息', ADD COLUMN source_table varchar(255) comment '来源表', ADD COLUMN source_id int(10) DEFAULT 0 comment '来源ID', ADD COLUMN source_user_id int(10) DEFAULT 0 comment '来源用户';
ALTER TABLE `registration_information` ADD COLUMN extra text comment '额外信息', ADD COLUMN source_table varchar(255) comment '来源表', ADD COLUMN source_id int(10) DEFAULT 0 comment '来源ID', ADD COLUMN source_user_id int(10) DEFAULT 0 comment '来源用户';
ALTER TABLE `travel_confirmation` ADD COLUMN extra text comment '额外信息', ADD COLUMN source_table varchar(255) comment '来源表', ADD COLUMN source_id int(10) DEFAULT 0 comment '来源ID', ADD COLUMN source_user_id int(10) DEFAULT 0 comment '来源用户';
insert into `auth` values ('1','管理员','普通用户','regular_user','普通用户','/regular_user/table','','0','','_blank','1','1','1','1','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('2','管理员','普通用户','regular_user','用户详情','/regular_user/view','','0','','_blank','1','1','1','1','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('3','管理员','主办用户','host_user','主办用户','/host_user/table','','0','','_blank','1','1','1','1','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{"examine":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('4','管理员','主办用户','host_user','用户详情','/host_user/view','','0','','_blank','1','1','1','1','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('5','管理员','会展信息','exhibition_information','会展信息','/exhibition_information/table','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"examine":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('6','管理员','会展信息','exhibition_information','信息详情','/exhibition_information/view','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('7','管理员','会展信息','exhibition_information','会展信息','/exhibition_information/list','','0','top','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('8','管理员','会展信息','exhibition_information','信息详情','/exhibition_information/details','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('9','管理员','展位信息','booth_information','展位信息','/booth_information/table','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"examine":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('10','管理员','展位信息','booth_information','信息详情','/booth_information/view','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('11','管理员','展位信息','booth_information','展位信息','/booth_information/list','','0','top','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('12','管理员','展位信息','booth_information','信息详情','/booth_information/details','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('13','管理员','报名信息','registration_information','报名信息','/registration_information/table','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"examine":true,"pay":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('14','管理员','报名信息','registration_information','信息详情','/registration_information/view','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"can_limits":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('15','管理员','报名信息','registration_information','报名信息','/registration_information/edit','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('16','管理员','行程确认','travel_confirmation','行程确认','/travel_confirmation/table','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{"figure":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('17','管理员','行程确认','travel_confirmation','确认详情','/travel_confirmation/view','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('18','管理员','退款申请','refund_request','退款申请','/refund_request/table','','0','','_blank','1','1','1','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{"examine":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('19','管理员','退款申请','refund_request','申请详情','/refund_request/view','','0','','_blank','1','1','1','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('20','管理员','消息通知','message_notification','消息通知','/message_notification/table','','0','','_blank','1','1','1','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{"figure":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('21','管理员','消息通知','message_notification','通知详情','/message_notification/view','','0','','_blank','1','1','1','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('22','管理员','会展公告','exhibition_announcement','会展公告','/exhibition_announcement/table','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('23','管理员','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/view','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('24','管理员','会展公告','exhibition_announcement','会展公告','/exhibition_announcement/list','','0','top','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('25','管理员','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/details','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('26','管理员','数据统计','data_statistics','数据统计','/data_statistics/table','','0','','_blank','1','1','1','1','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{"figure":true,"export_db":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('27','管理员','数据统计','data_statistics','统计详情','/data_statistics/view','','0','','_blank','1','1','1','1','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('28','管理员','会展资讯','article','会展资讯','/article/table','','0','','_blank','1','1','1','1','','','',null,'0','{"print":true,"export_db":true,"import_db":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('29','管理员','会展资讯','article','资讯详情','/article/view','','0','','_blank','1','1','1','1','','','',null,'0','{"print":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('30','管理员','会展资讯','article','会展资讯','/article/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('31','管理员','会展资讯','article','资讯详情','/article/details','','0','','_blank','1','1','1','1','','','',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('32','管理员','资讯分类','article_type','资讯分类','/article_type/table','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('33','管理员','资讯分类','article_type','分类详情','/article_type/view','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('34','管理员','平台公告','notice','平台公告','/notice/table','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('35','管理员','平台公告','notice','公告详情','/notice/view','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('36','管理员','平台公告','notice','平台公告','/notice/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('37','管理员','平台公告','notice','公告详情','/notice/details','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('38','管理员','我的收藏','collect','收藏记录','/collect/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('39','管理员','我的点赞','praise','点赞记录','/praise/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('40','管理员','评论','comment','评论管理','/comment/table','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('41','管理员','评论','comment','评论详情','/comment/view','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('42','管理员','评论','comment','我的评论','/comment/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('43','管理员','评论','comment','评论详情','/comment/details','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('44','游客','普通用户','regular_user','普通用户','/regular_user/table','','0','','_blank','1','0','0','0','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('45','游客','普通用户','regular_user','用户详情','/regular_user/view','','0','','_blank','1','0','0','0','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('46','游客','主办用户','host_user','主办用户','/host_user/table','','0','','_blank','1','0','0','0','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{"examine":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('47','游客','主办用户','host_user','用户详情','/host_user/view','','0','','_blank','1','0','0','0','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('48','游客','会展信息','exhibition_information','会展信息','/exhibition_information/table','','0','','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"examine":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('49','游客','会展信息','exhibition_information','信息详情','/exhibition_information/view','','0','','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('50','游客','会展信息','exhibition_information','会展信息','/exhibition_information/list','','0','top','_blank','0','0','0','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('51','游客','会展信息','exhibition_information','信息详情','/exhibition_information/details','','0','','_blank','0','0','0','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('52','游客','展位信息','booth_information','展位信息','/booth_information/table','','0','','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"examine":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('53','游客','展位信息','booth_information','信息详情','/booth_information/view','','0','','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('54','游客','展位信息','booth_information','展位信息','/booth_information/list','','0','top','_blank','0','0','0','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('55','游客','展位信息','booth_information','信息详情','/booth_information/details','','0','','_blank','0','0','0','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('56','游客','报名信息','registration_information','报名信息','/registration_information/table','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"examine":false,"pay":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('57','游客','报名信息','registration_information','信息详情','/registration_information/view','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"can_limits":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('58','游客','报名信息','registration_information','报名信息','/registration_information/edit','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('59','游客','行程确认','travel_confirmation','行程确认','/travel_confirmation/table','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{"figure":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('60','游客','行程确认','travel_confirmation','确认详情','/travel_confirmation/view','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('61','游客','退款申请','refund_request','退款申请','/refund_request/table','','0','','_blank','0','0','0','0','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{"examine":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('62','游客','退款申请','refund_request','申请详情','/refund_request/view','','0','','_blank','0','0','0','0','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('63','游客','消息通知','message_notification','消息通知','/message_notification/table','','0','','_blank','0','0','0','0','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{"figure":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('64','游客','消息通知','message_notification','通知详情','/message_notification/view','','0','','_blank','0','0','0','0','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('65','游客','会展公告','exhibition_announcement','展会公告','/exhibition_announcement/table','','0','','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('66','游客','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/view','','0','','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('67','游客','会展公告','exhibition_announcement','会展公告','/exhibition_announcement/list','','0','top','_blank','0','0','0','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('68','游客','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/details','','0','','_blank','0','0','0','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('69','游客','数据统计','data_statistics','数据统计','/data_statistics/table','','0','','_blank','0','0','0','0','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{"figure":false,"export_db":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('70','游客','数据统计','data_statistics','统计详情','/data_statistics/view','','0','','_blank','0','0','0','0','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('71','游客','会展资讯','article','会展资讯','/article/table','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false,"export_db":false,"import_db":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('72','游客','会展资讯','article','资讯详情','/article/view','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('73','游客','会展资讯','article','会展资讯','/article/list','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('74','游客','会展资讯','article','资讯详情','/article/details','','0','','_blank','0','0','0','1','','','',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('75','游客','资讯分类','article_type','资讯分类','/article_type/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('76','游客','资讯分类','article_type','分类详情','/article_type/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('77','游客','平台公告','notice','网站公告','/notice/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('78','游客','平台公告','notice','公告详情','/notice/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('79','游客','平台公告','notice','平台公告','/notice/list','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('80','游客','平台公告','notice','公告详情','/notice/details','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('81','游客','我的收藏','collect','收藏记录','/collect/list','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('82','游客','我的点赞','praise','点赞记录','/praise/list','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('83','游客','评论','comment','评论管理','/comment/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('84','游客','评论','comment','评论详情','/comment/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('85','游客','评论','comment','我的评论','/comment/list','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('86','游客','评论','comment','评论详情','/comment/details','','0','','_blank','0','0','0','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('87','普通用户','普通用户','regular_user','普通用户','/regular_user/table','','0','','_blank','0','0','0','0','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('88','普通用户','普通用户','regular_user','用户详情','/regular_user/view','','0','','_blank','0','0','1','1','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('89','普通用户','主办用户','host_user','主办用户','/host_user/table','','0','','_blank','0','0','0','0','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{"examine":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('90','普通用户','主办用户','host_user','用户详情','/host_user/view','','0','','_blank','0','0','0','0','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('91','普通用户','会展信息','exhibition_information','会展信息','/exhibition_information/table','','0','','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"examine":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('92','普通用户','会展信息','exhibition_information','信息详情','/exhibition_information/view','','0','','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('93','普通用户','会展信息','exhibition_information','会展信息','/exhibition_information/list','','0','top','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('94','普通用户','会展信息','exhibition_information','信息详情','/exhibition_information/details','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('95','普通用户','展位信息','booth_information','展位信息','/booth_information/table','','0','','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"examine":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('96','普通用户','展位信息','booth_information','信息详情','/booth_information/view','','0','','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('97','普通用户','展位信息','booth_information','展位信息','/booth_information/list','','0','top','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('98','普通用户','展位信息','booth_information','信息详情','/booth_information/details','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('99','普通用户','报名信息','registration_information','报名信息','/registration_information/table','','0','','_blank','0','1','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"examine":false,"pay":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('100','普通用户','报名信息','registration_information','信息详情','/registration_information/view','','0','','_blank','0','1','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"can_limits":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('101','普通用户','报名信息','registration_information','报名信息','/registration_information/edit','','0','','_blank','1','1','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('102','普通用户','行程确认','travel_confirmation','行程确认','/travel_confirmation/table','','0','','_blank','1','0','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{"figure":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('103','普通用户','行程确认','travel_confirmation','确认详情','/travel_confirmation/view','','0','','_blank','1','0','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('104','普通用户','退款申请','refund_request','退款申请','/refund_request/table','','0','','_blank','1','0','0','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{"examine":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('105','普通用户','退款申请','refund_request','申请详情','/refund_request/view','','0','','_blank','1','0','0','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('106','普通用户','消息通知','message_notification','消息通知','/message_notification/table','','0','','_blank','0','0','1','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{"figure":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('107','普通用户','消息通知','message_notification','通知详情','/message_notification/view','','0','','_blank','0','0','1','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('108','普通用户','会展公告','exhibition_announcement','展会公告','/exhibition_announcement/table','','0','','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('109','普通用户','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/view','','0','','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('110','普通用户','会展公告','exhibition_announcement','会展公告','/exhibition_announcement/list','','0','top','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('111','普通用户','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/details','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('112','普通用户','数据统计','data_statistics','数据统计','/data_statistics/table','','0','','_blank','0','0','0','0','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{"figure":false,"export_db":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('113','普通用户','数据统计','data_statistics','统计详情','/data_statistics/view','','0','','_blank','0','0','0','0','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('114','普通用户','会展资讯','article','会展资讯','/article/table','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false,"export_db":false,"import_db":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('115','普通用户','会展资讯','article','资讯详情','/article/view','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('116','普通用户','会展资讯','article','会展资讯','/article/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('117','普通用户','会展资讯','article','资讯详情','/article/details','','0','','_blank','1','1','1','1','','','',null,'0','{"can_comment":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('118','普通用户','资讯分类','article_type','资讯分类','/article_type/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('119','普通用户','资讯分类','article_type','分类详情','/article_type/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('120','普通用户','平台公告','notice','网站公告','/notice/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('121','普通用户','平台公告','notice','公告详情','/notice/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('122','普通用户','平台公告','notice','平台公告','/notice/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('123','普通用户','平台公告','notice','公告详情','/notice/details','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('124','普通用户','我的收藏','collect','收藏记录','/collect/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('125','普通用户','我的点赞','praise','点赞记录','/praise/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('126','普通用户','评论','comment','评论管理','/comment/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('127','普通用户','评论','comment','评论详情','/comment/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('128','普通用户','评论','comment','我的评论','/comment/list','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('129','普通用户','评论','comment','评论详情','/comment/details','','0','','_blank','1','1','1','1','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('130','主办用户','普通用户','regular_user','普通用户','/regular_user/table','','0','','_blank','0','0','0','0','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('131','主办用户','普通用户','regular_user','用户详情','/regular_user/view','','0','','_blank','0','0','0','0','user_name,users_mobile_phone','user_name,users_mobile_phone','user_name,users_mobile_phone',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('132','主办用户','主办用户','host_user','主办用户','/host_user/table','','0','','_blank','0','0','0','0','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{"examine":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('133','主办用户','主办用户','host_user','用户详情','/host_user/view','','0','','_blank','0','0','1','1','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate','company_name,company_phone,qualification_certificate',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('134','主办用户','会展信息','exhibition_information','会展信息','/exhibition_information/table','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"examine":false,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('135','主办用户','会展信息','exhibition_information','信息详情','/exhibition_information/view','','0','','_blank','1','1','1','1','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('136','主办用户','会展信息','exhibition_information','会展信息','/exhibition_information/list','','0','top','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('137','主办用户','会展信息','exhibition_information','信息详情','/exhibition_information/details','','0','','_blank','0','0','0','0','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t','exhibitionconvention_number,exhibition_theme,exhibition_and_convention_types,event_time,event_venue_name,exhibition_status,exhibition_poster,host_user,introduction_document,fee_standards,schedule_t',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('138','主办用户','展位信息','booth_information','展位信息','/booth_information/table','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"examine":true,"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('139','主办用户','展位信息','booth_information','信息详情','/booth_information/view','','0','','_blank','1','1','1','1','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('140','主办用户','展位信息','booth_information','展位信息','/booth_information/list','','0','top','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('141','主办用户','展位信息','booth_information','信息详情','/booth_information/details','','0','','_blank','0','0','0','0','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss','booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_location,booth_prices,booth_specifications,booth_images,booth_specificss',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('142','主办用户','报名信息','registration_information','报名信息','/registration_information/table','','0','','_blank','0','0','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"examine":true,"pay":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('143','主办用户','报名信息','registration_information','信息详情','/registration_information/view','','0','','_blank','0','0','1','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{"can_limits":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('144','主办用户','报名信息','registration_information','报名信息','/registration_information/edit','','0','','_blank','0','0','0','0','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,booth_name,booth_type,booth_prices,enrolled_user,user_name,users_mobile_phone,number_of_registrations,enterprise_qualifications,registration_notes,site_plan,exhibitor_documents',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('145','主办用户','行程确认','travel_confirmation','行程确认','/travel_confirmation/table','','0','','_blank','0','0','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{"figure":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('146','主办用户','行程确认','travel_confirmation','确认详情','/travel_confirmation/view','','0','','_blank','0','0','0','1','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees','order_number,booth_number,exhibitionconvention_number,exhibition_theme,host_user,enrolled_user,user_name,users_mobile_phone,confirm_time,number_of_attendees',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('147','主办用户','退款申请','refund_request','退款申请','/refund_request/table','','0','','_blank','0','0','0','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{"examine":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('148','主办用户','退款申请','refund_request','申请详情','/refund_request/view','','0','','_blank','0','0','0','1','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application','order_number,host_user,booth_prices,enrolled_user,user_name,users_mobile_phone,application_time,reason_for_application',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('149','主办用户','消息通知','message_notification','消息通知','/message_notification/table','','0','','_blank','1','1','0','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{"figure":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('150','主办用户','消息通知','message_notification','通知详情','/message_notification/view','','0','','_blank','1','1','0','1','notice_number,notice_title,notification_time,host_user,regular_user,notice_content','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status','notice_number,notice_title,notification_time,host_user,regular_user,notice_content,mark_status',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('151','主办用户','会展公告','exhibition_announcement','会展公告','/exhibition_announcement/table','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_show_comment":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('152','主办用户','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/view','','0','','_blank','1','1','1','1','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('153','主办用户','会展公告','exhibition_announcement','展会公告','/exhibition_announcement/list','','0','top','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('154','主办用户','会展公告','exhibition_announcement','公告详情','/exhibition_announcement/details','','0','','_blank','0','0','0','0','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content','announcement_title,announcement_type,exhibitionconvention_number,host_user,release_time,announcement_image,announcement_vuser_ideo,announcement_content',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('155','主办用户','数据统计','data_statistics','数据统计','/data_statistics/table','','0','','_blank','1','1','1','1','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{"figure":true,"export_db":true}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('156','主办用户','数据统计','data_statistics','统计详情','/data_statistics/view','','0','','_blank','1','1','1','1','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user','statistics_number,statistics_type,statistical_indicators,statistics_date,statistical_results,host_user',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('157','主办用户','会展资讯','article','会展资讯','/article/table','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false,"export_db":false,"import_db":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('158','主办用户','会展资讯','article','资讯详情','/article/view','','0','','_blank','0','0','0','0','','','',null,'0','{"print":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('159','主办用户','会展资讯','article','会展资讯','/article/list','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('160','主办用户','会展资讯','article','资讯详情','/article/details','','0','','_blank','0','0','0','0','','','',null,'0','{"can_comment":false,"can_show_comment":false}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('161','主办用户','资讯分类','article_type','资讯分类','/article_type/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('162','主办用户','资讯分类','article_type','分类详情','/article_type/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('163','主办用户','平台公告','notice','网站公告','/notice/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('164','主办用户','平台公告','notice','公告详情','/notice/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('165','主办用户','平台公告','notice','网站公告','/notice/list','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('166','主办用户','平台公告','notice','公告详情','/notice/details','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('167','主办用户','我的收藏','collect','收藏记录','/collect/list','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('168','主办用户','我的点赞','praise','点赞记录','/praise/list','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('169','主办用户','评论','comment','评论管理','/comment/table','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('170','主办用户','评论','comment','评论详情','/comment/view','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('171','主办用户','评论','comment','我的评论','/comment/list','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('172','主办用户','评论','comment','评论详情','/comment/details','','0','','_blank','0','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `auth` values ('173','管理员','','user_track_log','用户行为追踪','/user_track_log/table','','0','','_blank','1','0','0','0','','','',null,'0','{}','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `user_group` values ('1','100','管理员',null,'','','0','0','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `user_group` values ('2','100','游客',null,'','','0','0','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `user_group` values ('3','100','普通用户',null,'regular_user','regular_user_id','0','3','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
insert into `user_group` values ('4','100','主办用户',null,'host_user','host_user_id','0','1','2026-04-16 21:03:34.0','2026-04-16 21:03:34.0');
ALTER TABLE `comment` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;
ALTER TABLE `collect` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;
ALTER TABLE `praise` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;
insert into `slides` values ('1','轮播图1','内容1','https://www.baidu.com','/api/upload/2039516678517161985.jpg','437','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0');
insert into `slides` values ('2','轮播图2','内容2','https://www.163.com','/api/upload/2039516689392992257.jpg','716','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0');
insert into `slides` values ('3','轮播图3','内容3','https://www.jd.com','/api/upload/2039516604873572353.jpg','606','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0');
insert into `article` values ('1','第十二届北京海外置业移民留学展，4月24-26日相约北京','展会','30','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p><span style="color: rgb(37, 37, 37);">随着国际交流的日益紧密，海外置业、移民及留学已是越来越多中高收入家庭的关注板块。自2023年以来，我国海外置业、移民及留学市场处于快速复苏阶段，预计在2025年全行业还将迎来持续增长。作为海外置业、移民及留学行业的风向标和晴雨表，Overseas P+I第十二届北京海外置业及移民留学展定于2025年4月24-26日再度于国家会议中心5A馆隆重举办。在往届展会成功举办基础上，第十二届北京海外置业移民留学展的规模将进一步扩大，并增设更多专业交流单元，深化专业观众及对口高端人群的宣传，继续促进行业渠道合作、获客交流及品牌宣发。</span></p><p>深化B端观众交流体验，鸡尾酒会、专业参观日将成亮点</p><p>&nbsp;</p><p>在往届成功举办的经验基础上，Overseas P+I第十二届北京海外置业及移民留学展将再度汇集来自来自日本、马来西亚、新加坡、美国、加拿大、英国、澳大利亚、德国、香港、希腊、西班牙、泰国、塞浦路斯、葡萄牙、迪拜、多米尼哥等众多国家和地区的近150个海外置业、移民及留学精品项目参展，吸引众多业内人士、渠道机构、中介机构以及广大海外意向高端家庭参观展会，再度构筑行业渠道拓展、获客交流及品牌推广的一站式展示平台。</p><p>&nbsp;</p><p>展会同期还将继续举办Overseas Days-第五届海外置业移民留学论坛暨项目说明会，设立超过30场行业论坛及项目宣讲会。届时，行业大咖、专家及业内人士将共聚一堂，分享最新的趋势及海外项目资讯，构筑海外置业移民留学行业不容错过的合作交流契机。</p><p><span style="color: rgb(37, 37, 37);">值得一提的是，为持续深化观众交流体验，第十二届北京海外置业移民留学展将首次开展专业参观日（即2025年4月24日），供来自全国各地的行业人士、中介机构及潜在合作方到场参观交流。并且，开展期间还将隆重举办Overseas P+I海外置业移民留学行业交流鸡尾酒会，广邀海外项目方、本土专业人士、中介机构到场交流，共话合作，共赢发展。</span></p><p><span class="ql-cursor">﻿</span>第十二届&amp;第十三届北京海外置业移民留学展,邀您勾勒美好蓝图！</p><p>&nbsp;</p><p>据悉，第十二届及第十三届北京海外置业、移民及留学展览会将分别于2025年4月24日至26日与11月6日至8日，在国家会议中心盛大举行。目前，两届展会的招募与宣传工作已全面启动，多个国际展团已确认参展，Overseas P+I展会品牌将在2025年得到进一步提升。</p><p>&nbsp;</p><p>在此，Overseas P+I组委会诚挚邀请所有对海外置业、移民及留学感兴趣的行业全产业链人士，以及有实际海外需求的大众家庭，于4月24-26日，11月6-8日前往国家会议中心，免费登记参观。在这里，您不仅可以获取最前沿的行业资讯，还能与业界众多海外项目方面对面交流，建立广泛联系。Overseas P+I将持续推动海外置业移民留学行业进步，共同勾勒出一个更加美好、多元化的合作蓝图！</p>','/api/upload/1872543800400805888.jpg',null);
insert into `article` values ('2','赴早春之约，送暖入五羊：2025广东国际泵阀展览会预登记正式开启','展会','996','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p>上海2024年12月25日/美通社/--明年的华南开春行业首展——2025广东泵阀展&amp;广东水展预登记已开启！</p><p>&nbsp;</p><p>愿与岁月共韶华，倚就春光逐梦马。当春风又绿江南岸，泵阀人再聚五羊城，共商创新大计，同谋行业发展。3月5日至7日，广州丨保利世贸博览馆，2025广东国际泵管阀展览会（下称"2025广东泵阀展"）与2025广东国际水处理技术与设备展览会（简称"2025广东水展"联袂而来，还不预约，更待何时。</p><p>新活力，新动力</p><p>&nbsp;</p><p>超2万件展品，见证革新和突破</p><p>&nbsp;</p><p>时值年末，"十四五"的征程已经能看到落幕的终点，2025年即将成为两个五年规划的交汇节点，承"十四五"之硕果，启"十五五"之蓝图。泵阀人在触底、复苏、奋进、逆市的大背景下为行业带来了无限力量，广东泵阀展也始终站在全球资源汇聚、行业风向引领、全产业链产品和技术荟萃的最前沿，打造多元化、高品质泵阀商贸"粤"动平台。</p><p>&nbsp;</p><p>于泵阀产业而言，我国"水网"蜕变的每一步都充斥着泵管阀的身影，也见证着泵管阀技术的革新与突破。整个"十四五"时期，泵管阀行业变革的脚步紧跟"水网"的脉搏，倚靠海绵城市建设、地下管廊体系重塑以及给排水系统迭代等巨大市场机遇，走出了波动上扬的行情，国产化替代势头迅猛。</p><p>&nbsp;</p><p>2025广东泵阀展将继续承载新时代的使命与责任，发挥行业风向标的作用，助力泵阀企业集中展示最新技术成果，产品设备以及解决方案。36,000平米的展示空间将荟萃泵、阀门、智能供水设备、排水设备、管道/管接件、执行机构、泵管阀配套产品、电机、风机、压缩机等超2万件产品，强势为行业注入新的活力和创新力。</p><p>&nbsp;</p><p>描摹整个华南泵阀行业历史进程，沉浮8载深耕不辍，2025广东泵阀展已经不仅仅是全行业的盛事，更是一个展望未来的窗口。2025广东泵阀展，欲携手所有展商共同审视行业前行的机遇和挑战，聚力凝心划下"十四五"终章的完美句点。</p><p>&nbsp;</p><p>新合作，新机遇</p><p>&nbsp;</p><p>上下游联动，国内外800＋品牌集结</p><p>&nbsp;</p><p>合作共赢，是一种胸怀，更是一种智慧。</p><p>&nbsp;</p><p>新形势，新选择，2025广东泵阀展也将秉承这一理念，以开放包容的姿态，搭建国际交流的桥梁，展现泵阀行业硬核实力的风采。格兰富、DAB、佩德罗、利欧、新界、澳升、首飞、南元、凌霄、三晶、凯迪、美宝、西子、凯鑫、三佑、协羽、宝琦、戈斯曼等800+优质展商同台，国内外大牌集结，预估达20,000名专业观众参展，业务版图链接全球。</p>','/api/upload/1872542688616644609.jpg',null);
insert into `article` values ('3','FITUR 2025将促进中国和西班牙之间的旅游业务，增加游客和航班数量','展会','461','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p>国际旅游贸易博览会将有来自中国的官方代表以及大量的商业参与。</p><p>&nbsp;</p><p>马德里2024年12月16日/美通社/--FITUR 2025将于1月22日至26日举行，由IFEMA MADRID主办，旨在促进中国和西班牙之间日益增长的旅游关系，游客人数和航班数量的增加就证明了这一点。除了通过西班牙中国旅游局的官方代表之外，还有众多中国公司，如旅游运营商、酒店技术解决方案或中国官方入境代理商。</p><p>&nbsp;根据Turespaña的数据，2024年前9个月，共有517,000名中国游客访问西班牙，与2019年相比，支出增长了17%。就其本身而言，西班牙对前往中国旅行的兴趣也有所增加，这反映在代理商和运输公司的预订量增加。作为欧洲旅游目的地，西班牙在中国市场的地位比以往任何时候都好。</p><p>&nbsp;</p><p>根据其国家移民局的数据，中国政府记录到2023年共有4.24亿人进出中国，比2022年同期增长266.5%。针对中国公民的签证豁免政策一直是鼓励来自中国的旅游业的关键因素，也是中国当局吸引国际游客的关键因素，到2025年底，包括西班牙在内的多个国家不再需要15天签证，这使得FITUR成为宣传自己作为目的地的理想场景。</p><p>&nbsp;</p><p>2024年上半年，根据中国分析公司FastData的数据，中国海外游客数量达到6071万人次，同比增长50.4%，比2019年回升74.7%。预计这一数字将在今年下半年增长，在2025年上半年达到2019年水平的90%。</p><p>&nbsp;</p><p>在连通性方面，西班牙直飞中国的航班频率增加了38%，与2019年相比，每周有44个航班，座位增加了55%。这一增长有助于支持西班牙旅游业的季节性消失，特别是在非高峰季节。</p><p>&nbsp;</p><p>2024年，FITUR吸引了9,000家公司、152个国家和超过250,000名游客。</p>','/api/upload/1872545320131362817.jpg',null);
insert into `article` values ('4','第136届广交会参展企业和活动数量创新高，力促全球贸易发展','展会','98','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p><span style="color: rgb(37, 37, 37);">广州2024年10月15日 /美通社/ -- 第136届中国进出口商品交易会（广交会）10月15日至11月4日在中国广州举行，其参展企业和活动数量再攀新高。本届广交会采用线上线下融合办展，分三期进行，旨在推动高质量发展，进一步扩大对外开放。</span></p><p><span class="ql-cursor">﻿</span>本届广交会展览总面积达155万平方米，共设55个展区，约74000个展位。线下参展企业逾3万家，其中出口企业2.94万家，较上届增长近800家。值得注意的是，有近4600家企业为首次亮相。</p><p><br></p><p>本届展会将继续深耕数字化创新，推出虚拟数字人、广交会APP等18项线上参展新功能。线上展览规模显著扩大，吸引了约4.8万家企业参展，上传产品达375万件，较上届企业数和产品数分别增长60%和50%。展会旨在通过专场产品发布、现场直播等创新手段，向全球推广品牌。</p><p><br></p><p>本届展会还实现新的里程碑，将举办超过750场贸易促进活动。这些丰富多彩的活动旨在助力企业洞悉行业趋势和国际市场动态，从而精准对接业务需求，开展高效贸易合作。同时，广交会携手全球实体企业和跨国巨头，在美国、法国、巴西、印尼、肯尼亚、澳大利亚等65个国家和地区举办250余场"贸易桥梁"对接活动。此外，还将举行近400场新品发布活动，覆盖工业制造、电子、家电、汽车、时尚等13个行业领域。</p><p><br></p><p>广交会副主任兼秘书长、中国对外贸易中心主任储士家透露，截至10月9日，第136届广交会已吸引12.5万名境外采购商预登记，同时有223家全球顶尖零售商确认参展，较上届同期增长24%。海外采购商的热情参与彰显了国际商界对中国产品的信赖，广交会将继续担当中国制造商与全球市场间的关键纽带。</p><p><br></p>','/api/upload/1872543337374810112.jpg',null);
insert into `article` values ('5','北京车展创新纷呈，移远通信网联赋能','展会','336','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p>北京2024年4月26日 /美通社/ -- 时隔四年，备受瞩目的2024（第十八届）北京国际汽车展览会于4月25日盛大开幕。在这场汽车行业盛会上，各大主流车企竞相炫技，众多全球首发车、概念车、新能源车在这里汇聚，深刻揭示了汽车产业的最新成果和发展潮流，令人目不暇接。</p><p><br></p><p>智能化与电动化是汽车产业的趋势所在。据不完全统计，在此次车展展示的车型中，有数十款采用移远的蜂窝通信、智能座舱、Wi-Fi/蓝牙、高精定位和天线等产品来支持车辆的智能化、网联化功能，包括智能语音交互、人脸识别、远程车辆控制、智能座舱、智能驾驶等，为用户带来炫酷驾驶体验的同时，也展现出了移远通信在车载领域丰厚的产品和技术沉淀，获得了众多客户的信任。</p><p><br></p><p>专注于车载技术演进和创新</p><p><br></p><p>作为全球领先的物联网和车联网整体解决方案供应商，移远通信入局车载领域已有近十年的时间，一直专注于车载无线通信、智能座舱、高精定位等产品的开发和车载应用的创新，并不断加大投入，积极参与5G、C-V2X、eCall、网联信息安全等技术的标准制定和测试，持续推动新技术的演进和落地。在车载5G、智能座舱、Wi-Fi 7、UWB、天线、高精定位等领域，移远通信取得了丰硕的成果。</p><p class="ql-align-center">移远通信专注于车载技术演进和创新，在车载领域布局完善</p><p><br></p><p>在车载蜂窝通信领域，从LTE、LTE-A到C-V2X再到5G，移远通信紧随蜂窝通信技术的演进，不断推出符合新标准的车载产品。在5G R15方面，移远通信取得了辉煌的成果，其率先发布和量产的车规级5G模组AG55xQ/AG56xN系列，已被约20家主流车厂在多平台项目上选用。为了更大程度满足全球车厂和Tier 1供应商对车载5G的需求，移远通信还推出了多款符合3GPP R16标准的车规级5G模组，其中AG59x系列紧贴客户市场需求，已拿下了多个国内和全球车厂定点项目。</p><p><br></p><p>在智能座舱领域，随着汽车座舱逐步向大屏化、多屏化的趋势演进，移远通信基于高通第三代车规级智能座舱芯片SA8155P，推出了高性能SIP封装智能座舱模组AG855G。该模组性能强大，能够支持新一代智能汽车所需的更高计算能力和流畅的智能交互水平，自推出以来广受关注，已赢得了多个车厂项目，目前已实现大批量交付。同时在系统方案层级，针对多屏多应用的LXC 容器方案也领先市场量产。</p><p><br></p><p>除了车载通信和智能座舱外，移远通信还在车载天线领域取得了重要突破。为了更好地解决蜂窝信号因为损耗衰减所带来的痛点问题，移远通信率先开发了车载蜂窝天线补偿器，该产品可在不改变原车其他通信硬件布置位置的前提下，实现信号发射和接收的双向补偿。另外，移远通信还可提供"模组+蜂窝天线补偿器+天线"的综合解决方案，来确保车载蜂窝网络的更佳表现。</p><p><br></p><p>始终坚持"客户第一"</p><p><br></p><p>在如此激烈的市场竞争之下，移远通信如何稳固在行业内的领先地位？</p><p><br></p><p>一直以来，移远通信始终秉承"客户第一"的理念。为了给客户带来更好的服务体验，移远通信不仅推出了丰富的车载产品组合，还打造了高效的技术研发和服务团队，以及专业的车规级生产制造体系，在车载产品的生产和交付等方面积累了丰富的经验，能够更好地满足海内外汽车客户的高标准、多样化需求。</p>','/api/upload/1872546874641088512.jpg',null);
insert into `article` values ('6','第7届成都药交会蓄势待发，2025年3月共谋医药健康产业新篇章','展会','89','0','2026-04-16 21:03:35.0','2026-04-16 21:03:35.0',null,null,null,'<p>成都2024年12月23日/美通社/--在"健康中国"战略的引领下，我国医药健康产业正迎来前所未有的发展机遇。四川，四大产药区之一，且是全国首个国家中药现代化科技产业基地。成渝地区生物医药集群，上榜工业和信息化部近日公布的《2024年国家先进制造业集群名单》。成都生物医药产业集群是国家首批战略性新兴产业集群，同时也是成都瞄准干亿规模培育的潜力产业。</p><p>&nbsp;</p><p>成都药交会正是依托这一坚实的产业基础而创办，并始终致力于打造高质量、专业化、权威性医药健康产业链交流与采购平台。第7届成都医药健康产业博览会定于2025年3月7-9日，在成都世纪城国际展览中心举办，为医药健康产业的供需双方搭建高效对接的桥梁，助力医药健康产业新质生产力的发展。</p><p>&nbsp;</p><p>多个相关政府部门、行业协会支持，共创高质量药交会</p><p>&nbsp;</p><p>第7届成都药交会，在四川省经济和信息化厅、四川省商务厅和其他省级相关涉药涉医部门的指导下，由四川省医药行业协会联合四川省执业药师协会及其他省内相关协会主办，北京、天津、安徽、河南、广西、重庆、云南、陕西、河北等省（市）的医药行业协会共同支持，成都世纪康博会展有限公司具体承办。</p><p>&nbsp;</p><p>四川省级相关部门、行业协会和其他省市医药行业协会的参与，极大地丰富了药交会的内容与形式，其将通过各自的渠道邀请本地的医药生产企业、流通企业、医疗机构等到场参展参观。同时，相关单位、行业协会的领导届时也将莅临博览会现场参观指导。</p><p>聚焦生物医药，展示医药健康产业链的新成果与技术</p><p>&nbsp;</p><p>近年来，成都生物医药产业迅速崛起，已经成为中国生物医药版图的重要一极。作为医药健康领域的专业盛会，本届成都药交会将重点展示生物医药领域的新研发成果、前沿技术和创新产品，从基因治疗、细胞治疗到生物类似药，从疫苗研发到生物制药设备等。此外，展览内容还包括核医药，化学药，中成药，中药材、中药饮片及配方颗粒，中医药养生产品，健康营养及保健产品，卫生消毒产品、护理用品，中医医疗器械、家用医疗器械，制药机械及包装材料，医药物流技术与设备……众多医药健康产品将集中展示。</p><p>&nbsp;</p><p>药交会同期还将举办第32届成都医疗健康博览会、第8届成都老博会、第4届成都福祉博览会，预计展览面积共达60,000平方米，参展企业超1200家，专业观众将突破50,000人次。众多大健康企业将亮相展会现场，共同探寻行业新趋势与新商机。</p><p>同期10+行业交流会议，汇聚行业精英，共探发展新机</p><p>&nbsp;</p><p>成都药交会不仅是一个展览展示平台，更是一个汇聚行业智慧、推动行业交流发展的盛会。同期拟将举办医药供应链管理信息化创新与实践大会、医药新零售交流会、中医药创新发展交流会议、医疗机构药事管理创新发展会议、未来医疗器械产业转型升级会议、西部医院建设与管理大会、社会办医发展大会等10余场行业会议，旨在多角度探讨医药健康产业的最新趋势和发展机遇。会议将吸引到来自各地的相关政府单位领导、行业协会领导、医药企业负责人、流通企业负责人、医疗机构领导及科室负责人等到场参会并参观。通过会议，展商可以深入了解市场需求、把握行业脉搏，同时拓展人脉资源，寻找潜在的合作伙伴。</p><p>精准邀约优质观众参观，搭建高效商贸交流平台</p><p>&nbsp;</p><p>成都药交会不仅是企业品牌宣传的平台，更是一个商贸合作、开拓市场的平台。第7届成都药交会将加大展会宣传力度，充分利用展会自身累积的15万行业数据进行精准观众邀约，并与100多家行业网络媒体、10家医药杂志达成长期宣传合作，邀请各地医药代理商/经销商、各地医疗机构/医院领导及科室主任、药店与诊所负责人等多类专业人士到场参观采购，搭建高效商贸对接平台，助展商实现贸易合作与品牌推广双赢。</p><p>成都药交会目前已经举办6届，专业度不断得到业界肯定，是药企与代理商、经销商和终端客户等增强合作、拓展渠道的绝佳平台。全国各地越来越多的医药企业通过成都药交会的平台，在西部地区打响了品牌、彰显了实力、宣传了产品、拓展了市场。</p><p>&nbsp;</p><p>2025年3月7-9日在成都世纪城国际展览中心举办的“第7届成都药交会”招商招展工作正在火热进行中，诚邀全国医药企业、广大行业人士积极参与。</p>','/api/upload/1872544538984185857.jpg',null);
insert into `article_type` values ('1','100','展会','0',null,null,null,'2026-04-16 21:03:35.0','2026-04-16 21:03:35.0');
