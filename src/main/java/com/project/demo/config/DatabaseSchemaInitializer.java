package com.project.demo.config;

import com.project.demo.constant.LogicalDeleteConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class DatabaseSchemaInitializer implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    public DatabaseSchemaInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(ApplicationArguments args) {
        for (String table : LogicalDeleteConfig.tables()) {
            ensureLogicalDeleteColumns(table);
        }
        ensureRegistrationStateColumns();
    }

    private void ensureLogicalDeleteColumns(String table) {
        if (!tableExists(table)) {
            return;
        }
        addColumnIfMissing(table, LogicalDeleteConfig.COLUMN,
                "`is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除'");
        addColumnIfMissing(table, LogicalDeleteConfig.DELETED_TIME_COLUMN,
                "`deleted_time` datetime DEFAULT NULL COMMENT '逻辑删除时间'");
        addColumnIfMissing(table, LogicalDeleteConfig.DELETED_REASON_COLUMN,
                "`deleted_reason` varchar(500) DEFAULT '' COMMENT '逻辑删除原因'");
        addIndexIfMissing(table, "idx_" + table + "_is_deleted", "`is_deleted`");
    }

    private void ensureRegistrationStateColumns() {
        String table = "registration_information";
        if (!tableExists(table)) {
            return;
        }
        addColumnIfMissing(table, "expire_time",
                "`expire_time` datetime DEFAULT NULL COMMENT '支付过期时间'");
        addColumnIfMissing(table, "payment_time",
                "`payment_time` datetime DEFAULT NULL COMMENT '支付时间'");
        addColumnIfMissing(table, "refund_status",
                "`refund_status` varchar(32) DEFAULT NULL COMMENT '退款状态'");
        addIndexIfMissing(table, "idx_registration_payment_expire",
                "`pay_state`, `registration_status`, `expire_time`");
    }

    private boolean tableExists(String table) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?",
                    Integer.class,
                    table);
            return count != null && count > 0;
        } catch (Exception e) {
            log.warn("检查表结构失败: {}", table, e);
            return false;
        }
    }

    private void addColumnIfMissing(String table, String column, String definition) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?",
                    Integer.class,
                    table,
                    column);
            if (count == null || count > 0) {
                return;
            }
            jdbcTemplate.execute("ALTER TABLE `" + table + "` ADD COLUMN " + definition);
            log.info("已补齐逻辑删除字段: {}.{}", table, column);
        } catch (Exception e) {
            log.warn("补齐逻辑删除字段失败: {}.{}", table, column, e);
        }
    }

    private void addIndexIfMissing(String table, String indexName, String columns) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?",
                    Integer.class,
                    table,
                    indexName);
            if (count == null || count > 0) {
                return;
            }
            jdbcTemplate.execute("ALTER TABLE `" + table + "` ADD INDEX `" + indexName + "` (" + columns + ")");
            log.info("已补齐逻辑删除索引: {}.{}", table, indexName);
        } catch (Exception e) {
            log.warn("补齐逻辑删除索引失败: {}.{}", table, indexName, e);
        }
    }
}
