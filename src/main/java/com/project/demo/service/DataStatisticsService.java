package com.project.demo.service;

import com.project.demo.entity.DataStatistics;
import com.project.demo.service.base.BaseService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据统计：(DataStatistics)表服务接口
 *
 */
@Service
public class DataStatisticsService extends BaseService<DataStatistics> {

    public static final String TYPE_REGISTRATION = "报名统计";
    public static final String TYPE_FINANCE = "财务统计";
    public static final String TYPE_TRAVEL = "行程统计";

    private static final List<String> REGISTRATION_INDICATORS = Arrays.asList("报名人数", "候补人数", "审核通过人数");
    private static final List<String> FINANCE_INDICATORS = Arrays.asList("成交额", "退款金额", "实际收入");
    private static final List<String> TRAVEL_INDICATORS = Arrays.asList("行程确认人数", "到场人数");

    private final JdbcTemplate jdbcTemplate;

    public DataStatisticsService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> businessStatisticsPage(Map<String, String> query) {
        String typeFilter = clean(query.get("statistics_type"));
        String indicatorFilter = clean(query.get("statistical_indicators"));

        List<Map<String, Object>> rows = businessStatisticsRows();
        List<Map<String, Object>> filtered = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> row : rows) {
            String rowType = clean(row.get("statistics_type"));
            String rowIndicator = clean(row.get("statistical_indicators"));
            if (!typeFilter.isEmpty() && !rowType.contains(typeFilter)) {
                continue;
            }
            if (!indicatorFilter.isEmpty() && !rowIndicator.contains(indicatorFilter)) {
                continue;
            }
            filtered.add(row);
        }

        Map<String, Object> page = new LinkedHashMap<String, Object>();
        page.put("list", filtered);
        page.put("count", filtered.size());
        return page;
    }

    public Map<String, Object> businessOverview() {
        Map<String, Object> overview = new LinkedHashMap<String, Object>();
        overview.put("registration_people", number(registrationPeopleSql()));
        overview.put("actual_attendee_people", number(actualAttendeePeopleSql()));
        overview.put("used_booth_count", number(usedBoothCountSql()));
        overview.put("travel_confirm_people", number(travelConfirmPeopleSql()));
        overview.put("refund_people", number(refundPeopleSql()));
        overview.put("deal_amount", number(dealAmountSql()));
        overview.put("refund_amount", number(refundAmountSql()));
        overview.put("actual_income", decimalValue(dealAmountSql()).subtract(decimalValue(refundAmountSql())));
        overview.put("metrics", businessStatisticsRows());
        return overview;
    }

    public boolean isValidTypeIndicator(String statisticsType, String indicator) {
        String type = clean(statisticsType);
        String metric = clean(indicator);
        if (TYPE_REGISTRATION.equals(type)) {
            return REGISTRATION_INDICATORS.contains(metric);
        }
        if (TYPE_FINANCE.equals(type)) {
            return FINANCE_INDICATORS.contains(metric);
        }
        if (TYPE_TRAVEL.equals(type)) {
            return TRAVEL_INDICATORS.contains(metric);
        }
        return false;
    }

    public Double calculateMetric(String statisticsType, String indicator) {
        String type = clean(statisticsType);
        String metric = clean(indicator);
        if (!isValidTypeIndicator(type, metric)) {
            return null;
        }
        if (TYPE_REGISTRATION.equals(type)) {
            if ("报名人数".equals(metric)) {
                return number(registrationPeopleSql()).doubleValue();
            }
            if ("候补人数".equals(metric)) {
                return number(waitlistPeopleSql()).doubleValue();
            }
            return number(approvedRegistrationPeopleSql()).doubleValue();
        }
        if (TYPE_FINANCE.equals(type)) {
            BigDecimal dealAmount = decimalValue(dealAmountSql());
            BigDecimal refundAmount = decimalValue(refundAmountSql());
            if ("成交额".equals(metric)) {
                return dealAmount.doubleValue();
            }
            if ("退款金额".equals(metric)) {
                return refundAmount.doubleValue();
            }
            return dealAmount.subtract(refundAmount).doubleValue();
        }
        if ("行程确认人数".equals(metric)) {
            return number(travelConfirmPeopleSql()).doubleValue();
        }
        return number(actualAttendeePeopleSql()).doubleValue();
    }

    private List<Map<String, Object>> businessStatisticsRows() {
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        addMetric(rows, TYPE_REGISTRATION, "报名人数", number(registrationPeopleSql()));
        addMetric(rows, TYPE_REGISTRATION, "候补人数", number(waitlistPeopleSql()));
        addMetric(rows, TYPE_REGISTRATION, "审核通过人数", number(approvedRegistrationPeopleSql()));
        BigDecimal dealAmount = decimalValue(dealAmountSql());
        BigDecimal refundAmount = decimalValue(refundAmountSql());
        addMetric(rows, TYPE_FINANCE, "成交额", dealAmount);
        addMetric(rows, TYPE_FINANCE, "退款金额", refundAmount);
        addMetric(rows, TYPE_FINANCE, "实际收入", dealAmount.subtract(refundAmount));
        addMetric(rows, TYPE_TRAVEL, "行程确认人数", number(travelConfirmPeopleSql()));
        addMetric(rows, TYPE_TRAVEL, "到场人数", number(actualAttendeePeopleSql()));
        return rows;
    }

    private void addMetric(List<Map<String, Object>> rows, String type, String indicator, Number value) {
        Map<String, Object> row = new LinkedHashMap<String, Object>();
        row.put("data_statistics_id", rows.size() + 1);
        row.put("statistics_number", "AUTO-" + (rows.size() + 1));
        row.put("statistics_type", type);
        row.put("statistical_indicators", indicator);
        row.put("statistics_date", Date.valueOf(LocalDate.now()));
        row.put("statistical_results", value == null ? 0 : value);
        row.put("host_user", null);
        rows.add(row);
    }

    private String activeRegistrationWhere() {
        return "IFNULL(is_deleted, 0) = 0 "
                + "AND IFNULL(registration_status, '') <> '" + RegistrationWaitlistService.STATUS_CANCELLED + "' ";
    }

    private String registrationPeopleSql() {
        return "SELECT COALESCE(SUM(IFNULL(number_of_registrations, 0)), 0) FROM registration_information "
                + "WHERE " + activeRegistrationWhere();
    }

    private String waitlistPeopleSql() {
        return "SELECT COALESCE(SUM(IFNULL(number_of_registrations, 0)), 0) FROM registration_information "
                + "WHERE IFNULL(is_deleted, 0) = 0 "
                + "AND registration_status IN ('" + RegistrationWaitlistService.STATUS_WAITLIST + "', '"
                + RegistrationWaitlistService.STATUS_WAITLIST_REVIEW + "')";
    }

    private String approvedRegistrationPeopleSql() {
        return "SELECT COALESCE(SUM(IFNULL(number_of_registrations, 0)), 0) FROM registration_information "
                + "WHERE " + activeRegistrationWhere()
                + "AND examine_state = '" + RegistrationWaitlistService.EXAMINE_APPROVED + "'";
    }

    private String dealAmountSql() {
        return "SELECT COALESCE(SUM(IFNULL(booth_prices, 0)), 0) FROM registration_information "
                + "WHERE " + activeRegistrationWhere()
                + "AND pay_state = '" + RegistrationWaitlistService.PAY_PAID + "'";
    }

    private String refundAmountSql() {
        return "SELECT COALESCE(SUM(IFNULL(rr.booth_prices, 0)), 0) FROM refund_request rr "
                + "JOIN registration_information ri ON rr.source_table = 'registration_information' "
                + "AND rr.source_id = ri.registration_information_id "
                + "WHERE IFNULL(rr.is_deleted, 0) = 0 AND IFNULL(ri.is_deleted, 0) = 0 "
                + "AND rr.examine_state = '" + RegistrationWaitlistService.EXAMINE_APPROVED + "'";
    }

    private String refundPeopleSql() {
        return "SELECT COUNT(*) FROM refund_request rr "
                + "JOIN registration_information ri ON rr.source_table = 'registration_information' "
                + "AND rr.source_id = ri.registration_information_id "
                + "WHERE IFNULL(rr.is_deleted, 0) = 0 AND IFNULL(ri.is_deleted, 0) = 0 "
                + "AND rr.examine_state = '" + RegistrationWaitlistService.EXAMINE_APPROVED + "'";
    }

    private String travelConfirmPeopleSql() {
        return "SELECT COALESCE(SUM(IFNULL(tc.number_of_attendees, 0)), 0) FROM travel_confirmation tc "
                + "JOIN registration_information ri ON tc.source_table = 'registration_information' "
                + "AND tc.source_id = ri.registration_information_id "
                + "WHERE IFNULL(tc.is_deleted, 0) = 0 AND IFNULL(ri.is_deleted, 0) = 0";
    }

    private String actualAttendeePeopleSql() {
        return "SELECT COALESCE(SUM(IFNULL(tc.number_of_attendees, 0)), 0) FROM travel_confirmation tc "
                + "JOIN registration_information ri ON tc.source_table = 'registration_information' "
                + "AND tc.source_id = ri.registration_information_id "
                + "WHERE IFNULL(tc.is_deleted, 0) = 0 AND IFNULL(ri.is_deleted, 0) = 0 "
                + "AND tc.examine_state = '" + RegistrationWaitlistService.EXAMINE_APPROVED + "'";
    }

    private String usedBoothCountSql() {
        return "SELECT COUNT(DISTINCT source_id) FROM registration_information "
                + "WHERE " + activeRegistrationWhere()
                + "AND source_table = '" + RegistrationWaitlistService.SOURCE_TABLE_BOOTH + "' "
                + "AND source_id IS NOT NULL AND source_id > 0";
    }

    private Number number(String sql) {
        Number value = jdbcTemplate.queryForObject(sql, Number.class);
        return value == null ? 0 : value;
    }

    private BigDecimal decimalValue(String sql) {
        Number value = number(sql);
        return value == null ? BigDecimal.ZERO : new BigDecimal(String.valueOf(value));
    }

    private String clean(Object rawValue) {
        if (rawValue == null) {
            return "";
        }
        String value = String.valueOf(rawValue).trim();
        return "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value) ? "" : value;
    }
}
