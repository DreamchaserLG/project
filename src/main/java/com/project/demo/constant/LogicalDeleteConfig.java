package com.project.demo.constant;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public final class LogicalDeleteConfig {

    public static final String COLUMN = "is_deleted";
    public static final String DELETED_TIME_COLUMN = "deleted_time";
    public static final String DELETED_REASON_COLUMN = "deleted_reason";

    private static final Set<String> TABLES = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList(
            "registration_information",
            "travel_confirmation",
            "refund_request",
            "exhibition_information",
            "booth_information",
            "data_statistics"
    )));

    private LogicalDeleteConfig() {
    }

    public static boolean hasLogicalDelete(String tableName) {
        return TABLES.contains(tableName);
    }

    public static Set<String> tables() {
        return TABLES;
    }

    public static String visibleWhere() {
        return "IFNULL(" + COLUMN + ", 0) = 0";
    }
}
