package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.constant.FindConfig;
import com.project.demo.entity.RefundRequest;
import com.project.demo.service.AuditLogService;
import com.project.demo.service.BusinessAccessService;
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
    private final AuditLogService auditLogService;
    private final BusinessAccessService accessService;

    @Autowired
    // Constructor injection keeps refund review and waitlist promotion on the same transaction path.
    public RefundRequestController(RefundRequestService service,
                                   JdbcTemplate jdbcTemplate,
                                   RegistrationWaitlistService registrationWaitlistService,
                                   AuditLogService auditLogService,
                                   BusinessAccessService accessService) {
        setService(service);
        this.jdbcTemplate = jdbcTemplate;
        this.registrationWaitlistService = registrationWaitlistService;
        this.auditLogService = auditLogService;
        this.accessService = accessService;
    }

    @RequestMapping("/get_list")
    public Map<String, Object> getList(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request));
        Map<String, Object> map = service.selectToPage(service.readQuery(request), config);
        return success(map);
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put("like", "0");
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request));
        List resultList = service.selectBaseList(service.select(service.readQuery(request), config));
        if (resultList.size() > 0) {
            com.alibaba.fastjson.JSONObject jsonObject = new com.alibaba.fastjson.JSONObject();
            jsonObject.put("obj", resultList.get(0));
            return success(jsonObject);
        }
        return success(null);
    }

    @RequestMapping(value = {"/count_group", "/count"})
    public Map<String, Object> count(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request));
        Integer value = service.selectSqlToInteger(service.groupCount(service.readQuery(request), config));
        return success(value);
    }

    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        if (!actor.isLoggedIn()) {
            return error(30000, "请先登录后再申请退款");
        }

        Integer registrationId = resolveRegistrationId(paramMap);
        if (registrationId != null) {
            paramMap.put("source_table", RegistrationWaitlistService.SOURCE_TABLE_REGISTRATION);
            paramMap.put("source_id", registrationId);
        }
        String permissionMessage = accessService.requireRegistrationOwner(registrationId, actor);
        if (permissionMessage != null) {
            return error(30000, permissionMessage);
        }
        applyActorForAdd(paramMap, actor);
        String validateMessage = registrationWaitlistService.validateRefundRequestAllowed(registrationId);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }

        RefundRequest refundRequest = buildRefundRequest(paramMap, true);
        this.addEntity(refundRequest);

        registrationWaitlistService.markRefundRequestPending(registrationId);
        auditLogService.record(request, intValue(paramMap.get("create_by")), "申请退款", "refund_request",
                null, "成功", "报名记录ID：" + registrationId);

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
        Integer refundRequestId = getRefundRequestId(queryMap, paramMap);
        String auditExamineState = stringValue(paramMap.get("examine_state"));
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        if (refundRequestId != null && isAuditPayload(paramMap) && auditExamineState != null) {
            String permissionMessage = accessService.requireReviewAccess(
                    "refund_request", "refund_request_id", refundRequestId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
            if (actor.isHost() && isTerminalRefundState(refundRequestId)) {
                return error(30000, "当前退款申请已审核，请勿重复审核");
            }
            String repeatMessage = validateAuditNotRepeated(refundRequestId);
            if (repeatMessage != null) {
                return error(30000, repeatMessage);
            }
        } else if (refundRequestId != null) {
            String permissionMessage = accessService.requireViewAccess(
                    "refund_request", "refund_request_id", refundRequestId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
        }
        markAppealResolvedIfNeeded(queryMap, paramMap, refundRequest);
        this.setEntity(queryMap, configMap, refundRequest);

        Integer registrationId = getRefundSourceId(queryMap, paramMap, refundRequest);
        if (registrationId != null) {
            handleRefundStateChange(registrationId, String.valueOf(paramMap.get("examine_state")), refundRequest.getExamine_reply());
        }
        if (auditExamineState != null) {
            auditLogService.record(request, "审核退款", "refund_request",
                    refundRequestId, "成功", auditExamineState);
        }

        return success(1);
    }

    @PostMapping("/escalate/{refundRequestId}")
    @Transactional
    public Map<String, Object> escalateToAdmin(@PathVariable Integer refundRequestId,
                                               HttpServletRequest request) throws IOException {
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        String permissionMessage = accessService.requireViewAccess(
                "refund_request", "refund_request_id", refundRequestId, actor);
        if (permissionMessage != null) {
            return error(30000, permissionMessage);
        }
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
    public String updateExamineState(Long id, String newState, HttpServletRequest request) throws IOException {
        if (!RegistrationWaitlistService.EXAMINE_PENDING.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_APPROVED.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_REJECTED.equals(newState)) {
            return "非法的审核状态";
        }

        if (id == null) {
            return "审核失败：退款申请不存在";
        }

        BusinessAccessService.Actor actor = accessService.currentActor(request);
        String permissionMessage = accessService.requireReviewAccess(
                "refund_request", "refund_request_id", id.intValue(), actor);
        if (permissionMessage != null) {
            return permissionMessage;
        }

        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("refund_request_id", String.valueOf(id));
        RefundRequest refundRequest = service.findOne(queryMap);
        if (refundRequest == null) {
            return "审核失败：退款申请不存在";
        }

        refundRequest.setExamine_state(newState);
        if ("已申诉".equals(refundRequest.getEscalate_state())
                && (RegistrationWaitlistService.EXAMINE_APPROVED.equals(newState)
                || RegistrationWaitlistService.EXAMINE_REJECTED.equals(newState))) {
            refundRequest.setEscalate_state("已处理");
        }
        this.setEntity(queryMap, new HashMap<String, String>(), refundRequest);

        if (refundRequest.getSource_id() != null) {
            handleRefundStateChange(refundRequest.getSource_id(), newState, refundRequest.getExamine_reply());
        }

        return "审核成功";
    }

    private void applyActorForAdd(Map<String, Object> paramMap, BusinessAccessService.Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return;
        }
        if (actor.isRegular()) {
            paramMap.put("create_by", actor.getUserId());
            paramMap.put("source_user_id", actor.getUserId());
        } else {
            putIfMissing(paramMap, "create_by", actor.getUserId());
        }
    }

    private RefundRequest buildRefundRequest(Map<String, Object> paramMap, boolean isAdd) {
        RefundRequest refundRequest = new RefundRequest();
        fillFromRegistration(paramMap);

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
        } else if (isAdd) {
            refundRequest.setApplication_time(new java.sql.Timestamp(System.currentTimeMillis()));
        }

        refundRequest.setReason_for_application(stringValue(paramMap.get("reason_for_application")));
        if (isAdd) {
            refundRequest.setExamine_state(defaultString(paramMap.get("examine_state"), RegistrationWaitlistService.EXAMINE_PENDING));
        } else if (paramMap.containsKey("examine_state")) {
            refundRequest.setExamine_state(stringValue(paramMap.get("examine_state")));
        }
        if (paramMap.containsKey("examine_reply")) {
            refundRequest.setExamine_reply(stringValue(paramMap.get("examine_reply")));
        }
        if (paramMap.containsKey("escalate_state")) {
            refundRequest.setEscalate_state(stringValue(paramMap.get("escalate_state")));
        }
        if (paramMap.containsKey("escalate_reason")) {
            refundRequest.setEscalate_reason(stringValue(paramMap.get("escalate_reason")));
        }
        refundRequest.setExtra(stringValue(paramMap.get("extra")));
        refundRequest.setSource_table(stringValue(paramMap.get("source_table")));
        refundRequest.setSource_id(intValue(paramMap.get("source_id")));
        refundRequest.setSource_user_id(intValue(paramMap.get("source_user_id")));
        refundRequest.setCreate_by(intValue(paramMap.get("create_by")));
        return refundRequest;
    }

    private void fillFromRegistration(Map<String, Object> paramMap) {
        Integer registrationId = intValue(paramMap.get("source_id"));
        if (registrationId == null || registrationId <= 0) {
            return;
        }
        Map<String, Object> registration = registrationWaitlistService.getRegistration(registrationId);
        if (registration == null) {
            return;
        }
        putIfMissing(paramMap, "order_number", registration.get("order_number"));
        putIfMissing(paramMap, "host_user", registration.get("host_user"));
        putIfMissing(paramMap, "booth_prices", registration.get("booth_prices"));
        putIfMissing(paramMap, "enrolled_user", registration.get("enrolled_user"));
        putIfMissing(paramMap, "user_name", registration.get("user_name"));
        putIfMissing(paramMap, "users_mobile_phone", registration.get("users_mobile_phone"));
        putIfMissing(paramMap, "source_user_id", registration.get("enrolled_user"));
        paramMap.put("source_table", RegistrationWaitlistService.SOURCE_TABLE_REGISTRATION);
    }

    private void putIfMissing(Map<String, Object> paramMap, String key, Object value) {
        if ((paramMap.get(key) == null || isBadValue(String.valueOf(paramMap.get(key)))) && value != null) {
            paramMap.put(key, value);
        }
    }

    private Integer resolveRegistrationId(Map<String, Object> paramMap) {
        Integer sourceId = intValue(paramMap.get("source_id"));
        if (sourceId != null && sourceId > 0) {
            return sourceId;
        }
        String orderNumber = stringValue(paramMap.get("order_number"));
        if (orderNumber == null) {
            return null;
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id FROM registration_information WHERE order_number = ? ORDER BY registration_information_id DESC LIMIT 1",
                orderNumber
        );
        return rows.isEmpty() ? null : intValue(rows.get(0).get("registration_information_id"));
    }

    private boolean isAuditPayload(Map<String, Object> paramMap) {
        if (paramMap == null || !paramMap.containsKey("examine_state")) {
            return false;
        }
        for (String key : paramMap.keySet()) {
            if (!"examine_state".equals(key)
                    && !"examine_reply".equals(key)
                    && !"refund_request_id".equals(key)
                    && !"id".equals(key)) {
                return false;
            }
        }
        return true;
    }

    private Integer getRefundRequestId(Map<String, String> queryMap, Map<String, Object> paramMap) {
        Object value = queryMap == null ? null : queryMap.get("refund_request_id");
        if (value == null && queryMap != null) {
            value = queryMap.get("id");
        }
        if (value == null && paramMap != null) {
            value = paramMap.get("refund_request_id");
        }
        return intValue(value);
    }

    private boolean isTerminalRefundState(Integer refundRequestId) {
        if (refundRequestId == null) {
            return false;
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT examine_state FROM refund_request WHERE refund_request_id = ? LIMIT 1",
                refundRequestId);
        if (rows.isEmpty()) {
            return false;
        }
        String state = stringValue(rows.get(0).get("examine_state"));
        return RegistrationWaitlistService.EXAMINE_APPROVED.equals(state)
                || RegistrationWaitlistService.EXAMINE_REJECTED.equals(state);
    }

    private String validateAuditNotRepeated(Integer refundRequestId) {
        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("refund_request_id", String.valueOf(refundRequestId));
        RefundRequest refundRequest = service.findOne(queryMap);
        if (refundRequest == null) {
            return "退款申请记录不存在";
        }
        String state = stringValue(refundRequest.getExamine_state());
        String escalateState = stringValue(refundRequest.getEscalate_state());
        if ((RegistrationWaitlistService.EXAMINE_APPROVED.equals(state)
                || RegistrationWaitlistService.EXAMINE_REJECTED.equals(state))
                && !"已申诉".equals(escalateState)) {
            return "当前退款申请已审核，请勿重复审核";
        }
        return null;
    }

    private String defaultString(Object rawValue, String defaultValue) {
        String value = stringValue(rawValue);
        return isBadValue(value) ? defaultValue : value;
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
