package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.RefundRequest;
import com.project.demo.service.RefundRequestService;
import com.project.demo.service.RegistrationWaitlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@RestController
@RequestMapping("/refund_request")
public class RefundRequestController extends BaseController<RefundRequest, RefundRequestService> {

    private final JdbcTemplate jdbcTemplate;
    private final RegistrationWaitlistService registrationWaitlistService;

    @Autowired
    // Constructor injection keeps refund review and waitlist promotion on the same transaction path.
    public RefundRequestController(RefundRequestService service,
                                   JdbcTemplate jdbcTemplate,
                                   RegistrationWaitlistService registrationWaitlistService) {
        setService(service);
        this.jdbcTemplate = jdbcTemplate;
        this.registrationWaitlistService = registrationWaitlistService;
    }

    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);

        Integer registrationId = intValue(paramMap.get("source_id"));
        String validateMessage = registrationWaitlistService.validateRefundRequestAllowed(registrationId);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }

        RefundRequest refundRequest = buildRefundRequest(paramMap, true);
        this.addEntity(refundRequest);

        registrationWaitlistService.markRefundRequestPending(registrationId);

        return success(1);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String, String> queryMap = service.readQuery(request);
        Map<String, String> configMap = service.readConfig(request);
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);

        RefundRequest refundRequest = buildRefundRequest(paramMap, false);
        markAppealResolvedIfNeeded(queryMap, paramMap, refundRequest);
        this.setEntity(queryMap, configMap, refundRequest);

        Integer registrationId = getRefundSourceId(queryMap, paramMap, refundRequest);
        if (registrationId != null) {
            handleRefundStateChange(registrationId, String.valueOf(paramMap.get("examine_state")), refundRequest.getExamine_reply());
        }

        return success(1);
    }

    @PostMapping("/escalate/{refundRequestId}")
    @Transactional
    public Map<String, Object> escalateToAdmin(@PathVariable Integer refundRequestId,
                                               HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = service.readBody(request.getReader());
        if (paramMap == null) {
            paramMap = new HashMap<String, Object>();
        }

        Map<String, Object> result = service.escalateToAdmin(refundRequestId, stringValue(paramMap.get("reason")));
        if (!Boolean.TRUE.equals(result.get("ok"))) {
            return error(30000, String.valueOf(result.get("message")));
        }

        return success(result);
    }

    @Transactional
    @GetMapping("/update_examine_state")
    public String updateExamineState(Long id, String newState) throws IOException {
        if (!RegistrationWaitlistService.EXAMINE_PENDING.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_APPROVED.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_REJECTED.equals(newState)) {
            return "非法的审核状态";
        }

        if (id == null) {
            return "审核失败：退款申请不存在";
        }

        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("refund_request_id", String.valueOf(id));
        RefundRequest refundRequest = service.findOne(queryMap);
        if (refundRequest == null) {
            return "审核失败：退款申请不存在";
        }

        refundRequest.setExamine_state(newState);
        this.setEntity(queryMap, new HashMap<String, String>(), refundRequest);

        if (refundRequest.getSource_id() != null) {
            handleRefundStateChange(refundRequest.getSource_id(), newState, refundRequest.getExamine_reply());
        }

        return "审核成功";
    }

    private RefundRequest buildRefundRequest(Map<String, Object> paramMap, boolean isAdd) {
        RefundRequest refundRequest = new RefundRequest();

        if (isAdd) {
            refundRequest.setOrder_number(buildRefundOrderNumber(paramMap));
        } else {
            String orderNumber = stringValue(paramMap.get("order_number"));
            if (!isBadValue(orderNumber)) {
                refundRequest.setOrder_number(orderNumber);
            }
        }

        refundRequest.setHost_user(intValue(paramMap.get("host_user")));
        refundRequest.setBooth_prices(doubleValue(paramMap.get("booth_prices")));
        refundRequest.setEnrolled_user(intValue(paramMap.get("enrolled_user")));
        refundRequest.setUser_name(stringValue(paramMap.get("user_name")));
        refundRequest.setUsers_mobile_phone(stringValue(paramMap.get("users_mobile_phone")));

        if (paramMap.get("application_time") != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("application_time")))) {
            refundRequest.setApplication_time(parseToTimestamp(String.valueOf(paramMap.get("application_time"))));
        }

        refundRequest.setReason_for_application(stringValue(paramMap.get("reason_for_application")));
        refundRequest.setExamine_state(stringValue(paramMap.get("examine_state")));
        refundRequest.setExamine_reply(stringValue(paramMap.get("examine_reply")));
        refundRequest.setEscalate_state(stringValue(paramMap.get("escalate_state")));
        refundRequest.setEscalate_reason(stringValue(paramMap.get("escalate_reason")));
        refundRequest.setExtra(stringValue(paramMap.get("extra")));
        refundRequest.setSource_table(stringValue(paramMap.get("source_table")));
        refundRequest.setSource_id(intValue(paramMap.get("source_id")));
        refundRequest.setSource_user_id(intValue(paramMap.get("source_user_id")));
        refundRequest.setCreate_by(intValue(paramMap.get("create_by")));
        return refundRequest;
    }

    private void markAppealResolvedIfNeeded(Map<String, String> queryMap,
                                            Map<String, Object> paramMap,
                                            RefundRequest refundRequest) {
        String examineState = stringValue(paramMap.get("examine_state"));
        if (!RegistrationWaitlistService.EXAMINE_APPROVED.equals(examineState)
                && !RegistrationWaitlistService.EXAMINE_REJECTED.equals(examineState)) {
            return;
        }

        Integer refundRequestId = queryMap == null ? null : intValue(queryMap.get("refund_request_id"));
        if (refundRequestId == null) {
            return;
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT escalate_state FROM refund_request WHERE refund_request_id = ? LIMIT 1",
                refundRequestId);
        if (!rows.isEmpty() && "已申诉".equals(stringValue(rows.get(0).get("escalate_state")))) {
            refundRequest.setEscalate_state("已处理");
        }
    }

    private void handleRefundStateChange(Integer registrationId, String examineState, String examineReply) {
        if (registrationId == null || isBadValue(examineState)) {
            return;
        }

        if (RegistrationWaitlistService.EXAMINE_APPROVED.equals(examineState)) {
            registrationWaitlistService.cancelRegistration(
                    registrationId,
                    "退款通过",
                    examineReply == null ? "" : examineReply
            );
            return;
        }

        if (RegistrationWaitlistService.EXAMINE_REJECTED.equals(examineState)) {
            registrationWaitlistService.restorePaidStateAfterRefundReject(registrationId);
        }
    }

    private Integer getRefundSourceId(Map<String, String> queryMap,
                                      Map<String, Object> paramMap,
                                      RefundRequest refundRequest) {
        if (refundRequest != null && refundRequest.getSource_id() != null) {
            return refundRequest.getSource_id();
        }

        Integer sourceId = intValue(paramMap.get("source_id"));
        if (sourceId != null) {
            return sourceId;
        }

        if (queryMap != null && queryMap.get("refund_request_id") != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT source_id FROM refund_request WHERE refund_request_id = ? LIMIT 1",
                    intValue(queryMap.get("refund_request_id"))
            );
            if (!rows.isEmpty()) {
                return intValue(rows.get(0).get("source_id"));
            }
        }

        return null;
    }

    private String buildRefundOrderNumber(Map<String, Object> paramMap) {
        String orderNumber = stringValue(paramMap.get("order_number"));
        if (!isBadValue(orderNumber)) {
            return orderNumber;
        }

        Integer registrationId = intValue(paramMap.get("source_id"));
        if (registrationId != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT order_number FROM registration_information WHERE registration_information_id = ? LIMIT 1",
                    registrationId
            );
            if (!rows.isEmpty()) {
                String registrationOrderNumber = stringValue(rows.get(0).get("order_number"));
                if (!isBadValue(registrationOrderNumber)) {
                    return registrationOrderNumber;
                }
            }
        }

        return "TK" + System.currentTimeMillis() + ThreadLocalRandom.current().nextInt(1000, 9999);
    }

    private void clearEmptyString(Map<String, Object> paramMap) {
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).trim().isEmpty();
        });
    }

    private String stringValue(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        String value = String.valueOf(rawValue).trim();
        return value.isEmpty() ? null : value;
    }

    private boolean isBadValue(String value) {
        if (value == null) {
            return true;
        }
        String normalized = value.trim();
        return normalized.isEmpty()
                || "null".equalsIgnoreCase(normalized)
                || "undefined".equalsIgnoreCase(normalized)
                || "nan".equalsIgnoreCase(normalized);
    }

    private Integer intValue(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        try {
            String value = String.valueOf(rawValue).trim();
            if (isBadValue(value)) {
                return null;
            }
            return Integer.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }

    private Double doubleValue(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        try {
            String value = String.valueOf(rawValue).trim();
            if (isBadValue(value)) {
                return null;
            }
            return Double.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
