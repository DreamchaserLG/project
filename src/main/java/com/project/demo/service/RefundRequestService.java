package com.project.demo.service;

import com.project.demo.entity.RefundRequest;
import com.project.demo.service.base.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 退款申请：(RefundRequest)表服务接口
 *
 */
@Service
public class RefundRequestService extends BaseService<RefundRequest> {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public RefundRequestService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public Map<String, Object> escalateToAdmin(Integer refundRequestId, String reason) {
        if (refundRequestId == null || refundRequestId <= 0) {
            return fail("退款申请不存在");
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT refund_request_id, order_number, examine_state, escalate_state, examine_reply, " +
                        "source_id, enrolled_user, create_by FROM refund_request WHERE refund_request_id = ? FOR UPDATE",
                refundRequestId);

        if (rows.isEmpty()) {
            return fail("退款申请不存在");
        }

        Map<String, Object> refundRequest = rows.get(0);
        String currentExamineState = safeString(refundRequest.get("examine_state"));
        String currentEscalateState = safeString(refundRequest.get("escalate_state"));

        if (!RegistrationWaitlistService.EXAMINE_REJECTED.equals(currentExamineState)) {
            return fail("只有审核未通过的退款申请才能向管理员申诉");
        }

        if ("已申诉".equals(currentEscalateState) || "已处理".equals(currentEscalateState)) {
            return fail("该退款申请已提交过申诉");
        }

        String escalateReason = safeString(reason);
        if (escalateReason.isEmpty()) {
            String rejectReply = safeString(refundRequest.get("examine_reply"));
            escalateReason = rejectReply.isEmpty()
                    ? "主办方拒绝退款，申请管理员复核"
                    : "主办方拒绝退款，申请管理员复核。未退款原因：" + rejectReply;
        }

        jdbcTemplate.update(
                "UPDATE refund_request SET examine_state = ?, escalate_state = ?, escalate_reason = ?, update_time = NOW() " +
                        "WHERE refund_request_id = ?",
                RegistrationWaitlistService.EXAMINE_PENDING,
                "已申诉",
                escalateReason,
                refundRequestId);

        Integer registrationId = toInt(refundRequest.get("source_id"));
        if (registrationId != null && registrationId > 0) {
            jdbcTemplate.update(
                    "UPDATE registration_information SET pay_state = ?, update_time = NOW() WHERE registration_information_id = ?",
                    RegistrationWaitlistService.PAY_REFUNDING,
                    registrationId);
        }

        notifyAdmin(refundRequest, escalateReason);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", true);
        result.put("refund_request_id", refundRequestId);
        result.put("examine_state", RegistrationWaitlistService.EXAMINE_PENDING);
        result.put("escalate_state", "已申诉");
        result.put("message", "已提交管理员申诉，等待管理员复核");
        return result;
    }

    private void notifyAdmin(Map<String, Object> refundRequest, String reason) {
        String orderNumber = safeString(refundRequest.get("order_number"));
        String title = "退款申诉提醒";
        String content = orderNumber.isEmpty()
                ? "有一条退款申请已提交管理员申诉，请及时复核。"
                : "订单 " + orderNumber + " 的退款申请已提交管理员申诉，请及时复核。";
        if (!safeString(reason).isEmpty()) {
            content += "申诉原因：" + reason;
        }

        jdbcTemplate.update(
                "INSERT INTO message_inform (user_id, title, state, type, content, create_time, update_time) " +
                        "VALUES (?, ?, ?, ?, ?, NOW(), NOW())",
                1,
                title,
                "1",
                "通知",
                content);
    }

    private Map<String, Object> fail(String message) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", false);
        result.put("message", message);
        return result;
    }

    private String safeString(Object rawValue) {
        if (rawValue == null) {
            return "";
        }

        String value = String.valueOf(rawValue).trim();
        if ("null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value) || "nan".equalsIgnoreCase(value)) {
            return "";
        }
        return value;
    }

    private Integer toInt(Object rawValue) {
        if (rawValue == null) {
            return null;
        }

        try {
            String value = String.valueOf(rawValue).trim();
            if (value.isEmpty() || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value)
                    || "nan".equalsIgnoreCase(value)) {
                return null;
            }
            return Integer.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
