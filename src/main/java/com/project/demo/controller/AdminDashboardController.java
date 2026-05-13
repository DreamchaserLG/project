package com.project.demo.controller;

import com.project.demo.service.RegistrationWaitlistService;
import com.project.demo.service.BusinessAccessService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin_dashboard")
public class AdminDashboardController {

    private final JdbcTemplate jdbcTemplate;
    private final BusinessAccessService accessService;

    public AdminDashboardController(JdbcTemplate jdbcTemplate, BusinessAccessService accessService) {
        this.jdbcTemplate = jdbcTemplate;
        this.accessService = accessService;
    }

    @GetMapping("/summary")
    public Map<String, Object> summary(HttpServletRequest request) {
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        if (!actor.isAdmin()) {
            return error("仅管理员可查看运营统计");
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("total_exhibitions", number("SELECT COUNT(*) FROM exhibition_information"));
        result.put("total_registration_people", number(
                "SELECT COALESCE(SUM(CASE WHEN registration_status IS NULL OR registration_status <> '" + RegistrationWaitlistService.STATUS_CANCELLED + "' THEN number_of_registrations ELSE 0 END), 0) FROM registration_information"));
        result.put("total_revenue", number(
                "SELECT COALESCE(SUM(CASE WHEN pay_state = '" + RegistrationWaitlistService.PAY_PAID + "' THEN booth_prices ELSE 0 END), 0) FROM registration_information"));
        result.put("pending_registration", number(
                "SELECT COUNT(*) FROM registration_information WHERE examine_state = '" + RegistrationWaitlistService.EXAMINE_PENDING + "'"));
        result.put("pending_refund", number(
                "SELECT COUNT(*) FROM refund_request WHERE examine_state = '" + RegistrationWaitlistService.EXAMINE_PENDING + "'"));
        result.put("pending_travel", number(
                "SELECT COUNT(*) FROM travel_confirmation WHERE examine_state = '" + RegistrationWaitlistService.EXAMINE_PENDING + "'"));
        Map<String, Object> wrapper = new HashMap<String, Object>();
        wrapper.put("result", result);
        return wrapper;
    }

    @GetMapping("/exhibition_stats")
    public Map<String, Object> exhibitionStats(HttpServletRequest request) {
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        if (!actor.isAdmin()) {
            return error("仅管理员可查看运营统计");
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT ei.exhibition_information_id, ei.exhibitionconvention_number, ei.exhibition_theme, ei.event_time, "
                        + "COALESCE(ri.registration_people, 0) AS registration_people, "
                        + "COALESCE(ri.registration_count, 0) AS registration_count, "
                        + "COALESCE(tc.attendee_people, 0) AS attendee_people, "
                        + "COALESCE(rr.refund_count, 0) AS refund_count, "
                        + "COALESCE(ri.revenue, 0) AS revenue, "
                        + "COALESCE(ri.revenue, 0) - COALESCE(rr.refund_amount, 0) AS profit "
                        + "FROM exhibition_information ei "
                        + "LEFT JOIN ( "
                        + "  SELECT exhibitionconvention_number, "
                        + "    SUM(CASE WHEN registration_status IS NULL OR registration_status <> ? THEN IFNULL(number_of_registrations, 0) ELSE 0 END) AS registration_people, "
                        + "    COUNT(*) AS registration_count, "
                        + "    SUM(CASE WHEN pay_state = ? THEN IFNULL(booth_prices, 0) ELSE 0 END) AS revenue "
                        + "  FROM registration_information GROUP BY exhibitionconvention_number "
                        + ") ri ON ri.exhibitionconvention_number = ei.exhibitionconvention_number "
                        + "LEFT JOIN ( "
                        + "  SELECT ri2.exhibitionconvention_number, SUM(CASE WHEN tc.examine_state = ? THEN IFNULL(tc.number_of_attendees, 0) ELSE 0 END) AS attendee_people "
                        + "  FROM travel_confirmation tc "
                        + "  JOIN registration_information ri2 ON tc.source_table = 'registration_information' AND tc.source_id = ri2.registration_information_id "
                        + "  GROUP BY ri2.exhibitionconvention_number "
                        + ") tc ON tc.exhibitionconvention_number = ei.exhibitionconvention_number "
                        + "LEFT JOIN ( "
                        + "  SELECT ri3.exhibitionconvention_number, "
                        + "    SUM(CASE WHEN rr.examine_state = ? THEN 1 ELSE 0 END) AS refund_count, "
                        + "    SUM(CASE WHEN rr.examine_state = ? THEN IFNULL(rr.booth_prices, 0) ELSE 0 END) AS refund_amount "
                        + "  FROM refund_request rr "
                        + "  JOIN registration_information ri3 ON rr.source_table = 'registration_information' AND rr.source_id = ri3.registration_information_id "
                        + "  GROUP BY ri3.exhibitionconvention_number "
                        + ") rr ON rr.exhibitionconvention_number = ei.exhibitionconvention_number "
                        + "ORDER BY ei.create_time DESC, ei.exhibition_information_id DESC LIMIT 8",
                RegistrationWaitlistService.STATUS_CANCELLED,
                RegistrationWaitlistService.PAY_PAID,
                RegistrationWaitlistService.EXAMINE_APPROVED,
                RegistrationWaitlistService.EXAMINE_APPROVED,
                RegistrationWaitlistService.EXAMINE_APPROVED
        );
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("list", rows);
        Map<String, Object> wrapper = new HashMap<String, Object>();
        wrapper.put("result", result);
        return wrapper;
    }

    private Map<String, Object> error(String message) {
        Map<String, Object> wrapper = new HashMap<String, Object>();
        Map<String, Object> error = new HashMap<String, Object>();
        error.put("code", 30000);
        error.put("message", message);
        wrapper.put("error", error);
        return wrapper;
    }

    private Number number(String sql) {
        Number value = jdbcTemplate.queryForObject(sql, Number.class);
        return value == null ? 0 : value;
    }
}
