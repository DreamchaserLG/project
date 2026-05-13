package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.constant.FindConfig;
import com.project.demo.entity.RegistrationInformation;
import com.project.demo.service.AuditLogService;
import com.project.demo.service.BusinessAccessService;
import com.project.demo.service.RegistrationInformationService;
import com.project.demo.service.RegistrationWaitlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
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
@RequestMapping("/registration_information")
public class RegistrationInformationController extends BaseController<RegistrationInformation, RegistrationInformationService> {

    private final RegistrationWaitlistService registrationWaitlistService;
    private final AuditLogService auditLogService;
    private final BusinessAccessService accessService;

    @Autowired
    public RegistrationInformationController(RegistrationInformationService service,
                                             RegistrationWaitlistService registrationWaitlistService,
                                             AuditLogService auditLogService,
                                             BusinessAccessService accessService) {
        setService(service);
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
            return error(30000, "请先登录后再报名");
        }
        applyActorForAdd(paramMap, actor);

        String numberMessage = validateRegistrationPeople(paramMap.get("number_of_registrations"));
        if (numberMessage != null) {
            return error(30000, numberMessage);
        }

        if (isBoothRegistration(paramMap)) {
            Map<String, Object> result = registrationWaitlistService.createBoothRegistration(paramMap);
            if (!Boolean.TRUE.equals(result.get("ok"))) {
                return error(30000, String.valueOf(result.get("message")));
            }
            auditLogService.record(request, intValue(paramMap.get("create_by")), "报名", "registration_information",
                    result.get("registration_information_id"), "成功", String.valueOf(result.get("message")));
            return success(result);
        }

        RegistrationInformation registrationInformation = buildRegistrationEntity(paramMap, true);

        String boothNumber = normalize(paramMap.get("booth_number"));
        if (isBadValue(boothNumber)) {
            boothNumber = "AUTO-" + registrationInformation.getOrder_number();
            registrationInformation.setBooth_number(boothNumber);
        }

        Map<String, String> query = new HashMap<String, String>();
        query.put("booth_number", boothNumber);
        List<?> exists = service.selectBaseList(service.select(query, new HashMap<String, String>()));
        if (!exists.isEmpty()) {
            return error(30000, "展位编号不能重复");
        }

        this.addEntity(registrationInformation);

        Integer registrationId = findRegistrationId(registrationInformation.getOrder_number());
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("registration_information_id", registrationId);
        result.put("order_number", registrationInformation.getOrder_number());
        result.put("registration_status", RegistrationWaitlistService.STATUS_CONFIRMED);
        result.put("waitlist_no", null);
        result.put("need_pay", false);
        result.put("message", "报名已提交，待管理员或主办方审核");
        auditLogService.record(request, intValue(paramMap.get("create_by")), "报名", "registration_information",
                registrationId, "成功", "新增报名记录");
        return success(result);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String, String> queryMap = service.readQuery(request);
        Map<String, String> configMap = service.readConfig(request);
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);

        if (paramMap.containsKey("number_of_registrations")) {
            String numberMessage = validateRegistrationPeople(paramMap.get("number_of_registrations"));
            if (numberMessage != null) {
                return error(30000, numberMessage);
            }
        }

        Integer registrationId = getRegistrationId(queryMap, paramMap);
        String auditExamineState = stringValue(paramMap.get("examine_state"));
        BusinessAccessService.Actor actor = accessService.currentActor(request);

        if (registrationId != null && isAuditPayload(paramMap) && auditExamineState != null) {
            String permissionMessage = accessService.requireReviewAccess(
                    "registration_information", "registration_information_id", registrationId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
            String repeatMessage = validateAuditNotRepeated(registrationId);
            if (repeatMessage != null) {
                return error(30000, repeatMessage);
            }
            Map<String, Object> result = registrationWaitlistService.auditRegistration(
                    registrationId,
                    auditExamineState,
                    stringValue(paramMap.get("examine_reply"))
            );
            if (!Boolean.TRUE.equals(result.get("ok"))) {
                return error(30000, String.valueOf(result.get("message")));
            }
            auditLogService.record(request, "审核报名", "registration_information",
                    registrationId, "成功", auditExamineState);
            return success(result);
        }

        if (registrationId != null) {
            String permissionMessage = accessService.requireViewAccess(
                    "registration_information", "registration_information_id", registrationId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
        }

        if (registrationId != null && RegistrationWaitlistService.PAY_PAID.equals(String.valueOf(paramMap.get("pay_state")))) {
            String paymentMessage = validatePaymentMethod(paramMap);
            if (paymentMessage != null) {
                return error(30000, paymentMessage);
            }
            String message = registrationWaitlistService.validatePaymentAllowed(registrationId);
            if (message != null) {
                return error(30000, message);
            }
        }

        RegistrationInformation registrationInformation = buildRegistrationEntity(paramMap, false);
        this.setEntity(queryMap, configMap, registrationInformation);
        auditLogService.record(request, intValue(paramMap.get("create_by")), "修改报名", "registration_information",
                registrationId, "成功", "更新报名信息");

        Object examineState = paramMap.get("examine_state");
        if (registrationId != null && RegistrationWaitlistService.EXAMINE_REJECTED.equals(String.valueOf(examineState))) {
            registrationWaitlistService.cancelRegistration(
                    registrationId,
                    "审核未通过",
                    paramMap.get("examine_reply") == null ? "" : String.valueOf(paramMap.get("examine_reply"))
            );
        }

        return success(1);
    }

    @PostMapping("/cancel/{registrationId}")
    @Transactional
    public Map<String, Object> cancel(@PathVariable Integer registrationId, HttpServletRequest request) {
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        String permissionMessage = accessService.requireViewAccess(
                "registration_information", "registration_information_id", registrationId, actor);
        if (permissionMessage != null) {
            return error(30000, permissionMessage);
        }
        Map<String, Object> result = registrationWaitlistService.cancelRegistration(
                registrationId,
                "取消报名",
                ""
        );
        if (!Boolean.TRUE.equals(result.get("ok"))) {
            return error(30000, String.valueOf(result.get("message")));
        }
        auditLogService.record(request, "取消报名", "registration_information", registrationId, "成功",
                String.valueOf(result.get("message")));
        return success(result);
    }

    @Transactional
    @GetMapping("/update_examine_state")
    public String updateExamineState(Long id, String newState, String examineReply, HttpServletRequest request) throws IOException {
        if (!RegistrationWaitlistService.EXAMINE_PENDING.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_APPROVED.equals(newState)
                && !RegistrationWaitlistService.EXAMINE_REJECTED.equals(newState)) {
            return "非法的审核状态";
        }

        if (id == null) {
            return "审核失败：报名记录不存在";
        }

        BusinessAccessService.Actor actor = accessService.currentActor(request);
        String permissionMessage = accessService.requireReviewAccess(
                "registration_information", "registration_information_id", id.intValue(), actor);
        if (permissionMessage != null) {
            return permissionMessage;
        }

        Map<String, Object> auditResultMap = registrationWaitlistService.auditRegistration(
                id.intValue(),
                newState,
                examineReply == null ? "" : examineReply
        );
        if (auditResultMap != null) {
            return String.valueOf(auditResultMap.get("message"));
        }

        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("registration_information_id", String.valueOf(id));
        RegistrationInformation registrationInformation = service.findOne(queryMap);
        if (registrationInformation == null) {
            return "审核失败：报名记录不存在";
        }

        if (RegistrationWaitlistService.EXAMINE_REJECTED.equals(newState)) {
            Map<String, Object> result = registrationWaitlistService.cancelRegistration(
                    id.intValue(),
                    "审核未通过",
                    examineReply == null ? "" : examineReply
            );
            return String.valueOf(result.get("message"));
        }

        registrationInformation.setExamine_state(newState);
        if (examineReply != null) {
            registrationInformation.setExamine_reply(examineReply);
        }
        this.setEntity(queryMap, new HashMap<String, String>(), registrationInformation);
        return "审核成功";
    }

    @Transactional
    @GetMapping("/update_pay_state")
    public String updatePayState(Long id, String newState, HttpServletRequest request) throws IOException {
        if (!RegistrationWaitlistService.PAY_UNPAID.equals(newState)
                && !RegistrationWaitlistService.PAY_PAID.equals(newState)
                && !RegistrationWaitlistService.PAY_REFUNDING.equals(newState)
                && !RegistrationWaitlistService.PAY_REFUNDED.equals(newState)) {
            return "非法的支付状态";
        }

        if (id == null) {
            return "支付失败：报名记录不存在";
        }

        BusinessAccessService.Actor actor = accessService.currentActor(request);
        String permissionMessage = accessService.requireViewAccess(
                "registration_information", "registration_information_id", id.intValue(), actor);
        if (permissionMessage != null) {
            return permissionMessage;
        }

        if (RegistrationWaitlistService.PAY_PAID.equals(newState)) {
            String message = registrationWaitlistService.validatePaymentAllowed(id.intValue());
            if (message != null) {
                return message;
            }
        }

        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("registration_information_id", String.valueOf(id));
        RegistrationInformation registrationInformation = service.findOne(queryMap);
        if (registrationInformation == null) {
            return "支付失败：报名记录不存在";
        }

        registrationInformation.setPay_state(newState);
        this.setEntity(queryMap, new HashMap<String, String>(), registrationInformation);
        return "支付成功";
    }

    private String validateRegistrationPeople(Object rawValue) {
        Double value = doubleValue(rawValue);
        if (value == null || value < 1) {
            return "报名人数不能小于1人";
        }
        if (Math.floor(value) != value) {
            return "报名人数必须为正整数";
        }
        return null;
    }

    private String validateAuditNotRepeated(Integer registrationId) {
        Map<String, String> queryMap = new HashMap<String, String>();
        queryMap.put("registration_information_id", String.valueOf(registrationId));
        RegistrationInformation registrationInformation = service.findOne(queryMap);
        if (registrationInformation == null) {
            return "报名记录不存在";
        }
        String state = stringValue(registrationInformation.getExamine_state());
        if (RegistrationWaitlistService.EXAMINE_APPROVED.equals(state)
                || RegistrationWaitlistService.EXAMINE_REJECTED.equals(state)) {
            return "当前报名已审核，请勿重复审核";
        }
        return null;
    }

    private String validatePaymentMethod(Map<String, Object> paramMap) {
        String payType = stringValue(paramMap.get("pay_type"));
        if ("微信".equals(payType) || "微信支付".equals(payType)
                || "支付宝".equals(payType) || "支付宝支付".equals(payType)) {
            return null;
        }
        return "仅支持微信支付或支付宝支付";
    }

    private void applyActorForAdd(Map<String, Object> paramMap, BusinessAccessService.Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return;
        }
        if (actor.isRegular()) {
            paramMap.put("enrolled_user", actor.getUserId());
            paramMap.put("create_by", actor.getUserId());
            paramMap.put("source_user_id", actor.getUserId());
        } else {
            putIfMissing(paramMap, "create_by", actor.getUserId());
        }
    }

    private RegistrationInformation buildRegistrationEntity(Map<String, Object> paramMap, boolean isAdd) {
        RegistrationInformation registrationInformation = new RegistrationInformation();

        if (isAdd) {
            registrationInformation.setOrder_number(buildOrderNumber(paramMap.get("order_number")));
        } else {
            String orderNumber = normalize(paramMap.get("order_number"));
            if (!isBadValue(orderNumber)) {
                registrationInformation.setOrder_number(orderNumber);
            }
        }

        String boothNumber = normalize(paramMap.get("booth_number"));
        if (isAdd || !isBadValue(boothNumber)) {
            registrationInformation.setBooth_number(boothNumber);
        }

        registrationInformation.setExhibitionconvention_number(stringValue(paramMap.get("exhibitionconvention_number")));
        registrationInformation.setExhibition_theme(stringValue(paramMap.get("exhibition_theme")));
        registrationInformation.setHost_user(intValue(paramMap.get("host_user")));
        registrationInformation.setBooth_name(stringValue(paramMap.get("booth_name")));
        registrationInformation.setBooth_type(stringValue(paramMap.get("booth_type")));
        registrationInformation.setBooth_prices(doubleValue(paramMap.get("booth_prices")));
        registrationInformation.setEnrolled_user(intValue(paramMap.get("enrolled_user")));
        registrationInformation.setUser_name(stringValue(paramMap.get("user_name")));
        registrationInformation.setUsers_mobile_phone(stringValue(paramMap.get("users_mobile_phone")));
        registrationInformation.setNumber_of_registrations(doubleValue(paramMap.get("number_of_registrations")));
        registrationInformation.setEnterprise_qualifications(stringValue(paramMap.get("enterprise_qualifications")));
        registrationInformation.setRegistration_notes(stringValue(paramMap.get("registration_notes")));
        registrationInformation.setSite_plan(stringValue(paramMap.get("site_plan")));
        registrationInformation.setExhibitor_documents(stringValue(paramMap.get("exhibitor_documents")));
        if (isAdd) {
            registrationInformation.setExamine_state(RegistrationWaitlistService.EXAMINE_PENDING);
            registrationInformation.setExamine_reply("");
        } else {
            registrationInformation.setExamine_state(stringValue(paramMap.get("examine_state")));
            registrationInformation.setExamine_reply(stringValue(paramMap.get("examine_reply")));
        }
        registrationInformation.setPay_state(isAdd ? RegistrationWaitlistService.PAY_UNPAID : stringValue(paramMap.get("pay_state")));
        registrationInformation.setPay_type(stringValue(paramMap.get("pay_type")));
        registrationInformation.setTravel_confirmation_limit_times(defaultString(paramMap.get("travel_confirmation_limit_times"), "1"));
        registrationInformation.setRefund_request_limit_times(defaultString(paramMap.get("refund_request_limit_times"), "1"));
        registrationInformation.setExtra(stringValue(paramMap.get("extra")));
        registrationInformation.setSource_table(stringValue(paramMap.get("source_table")));
        registrationInformation.setSource_id(intValue(paramMap.get("source_id")));
        registrationInformation.setSource_user_id(intValue(paramMap.get("source_user_id")));
        String registrationStatus = stringValue(paramMap.get("registration_status"));
        if (isAdd) {
            registrationInformation.setRegistration_status(RegistrationWaitlistService.STATUS_CONFIRMED);
        } else if (isValidRegistrationStatus(registrationStatus)) {
            registrationInformation.setRegistration_status(registrationStatus);
        }
        registrationInformation.setWaitlist_no(intValue(paramMap.get("waitlist_no")));
        registrationInformation.setCreate_by(intValue(paramMap.get("create_by")));
        return registrationInformation;
    }

    private boolean isValidRegistrationStatus(String registrationStatus) {
        return RegistrationWaitlistService.STATUS_CONFIRMED.equals(registrationStatus)
                || RegistrationWaitlistService.STATUS_WAITLIST.equals(registrationStatus)
                || RegistrationWaitlistService.STATUS_CANCELLED.equals(registrationStatus);
    }

    private boolean isBoothRegistration(Map<String, Object> paramMap) {
        return RegistrationWaitlistService.SOURCE_TABLE_BOOTH.equals(String.valueOf(paramMap.get("source_table")))
                && intValue(paramMap.get("source_id")) != null;
    }

    private void clearEmptyString(Map<String, Object> paramMap) {
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).trim().isEmpty();
        });
    }

    private void putIfMissing(Map<String, Object> paramMap, String key, Object value) {
        if (paramMap.get(key) == null || isBadValue(String.valueOf(paramMap.get(key)))) {
            paramMap.put(key, value);
        }
    }

    private Integer getRegistrationId(Map<String, String> queryMap, Map<String, Object> paramMap) {
        Object idValue = null;
        if (queryMap != null) {
            idValue = queryMap.get("registration_information_id");
            if (idValue == null) {
                idValue = queryMap.get("id");
            }
        }
        if (idValue == null && paramMap != null) {
            idValue = paramMap.get("registration_information_id");
        }
        if (idValue == null && paramMap != null) {
            idValue = paramMap.get("id");
        }
        return intValue(idValue);
    }

    private Integer findRegistrationId(String orderNumber) {
        if (isBadValue(orderNumber)) {
            return null;
        }

        List<Map<String, Object>> rows = service.selectMapBaseList(
                "SELECT registration_information_id FROM registration_information " +
                        "WHERE order_number = '" + orderNumber + "' ORDER BY registration_information_id DESC LIMIT 1"
        );

        if (rows == null || rows.isEmpty()) {
            return null;
        }

        return intValue(rows.get(0).get("registration_information_id"));
    }

    private boolean isAuditPayload(Map<String, Object> paramMap) {
        if (paramMap == null || !paramMap.containsKey("examine_state")) {
            return false;
        }

        for (String key : paramMap.keySet()) {
            if (!"examine_state".equals(key)
                    && !"examine_reply".equals(key)
                    && !"registration_information_id".equals(key)
                    && !"id".equals(key)) {
                return false;
            }
        }
        return true;
    }

    private String buildOrderNumber(Object rawValue) {
        String value = normalize(rawValue);
        if (!isBadValue(value)) {
            return value;
        }
        return "BM" + System.currentTimeMillis() + ThreadLocalRandom.current().nextInt(1000, 9999);
    }

    private String defaultString(Object rawValue, String defaultValue) {
        String value = stringValue(rawValue);
        return isBadValue(value) ? defaultValue : value;
    }

    private String stringValue(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        String value = String.valueOf(rawValue).trim();
        return value.isEmpty() ? null : value;
    }

    private String normalize(Object rawValue) {
        if (rawValue == null) {
            return "";
        }
        return String.valueOf(rawValue).trim();
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
