package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.constant.FindConfig;
import com.project.demo.entity.TravelConfirmation;
import com.project.demo.service.AuditLogService;
import com.project.demo.service.BusinessAccessService;
import com.project.demo.service.TravelConfirmationService;
import com.project.demo.service.RegistrationWaitlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/travel_confirmation")
public class TravelConfirmationController extends BaseController<TravelConfirmation, TravelConfirmationService> {

    private final RegistrationWaitlistService registrationWaitlistService;
    private final AuditLogService auditLogService;
    private final JdbcTemplate jdbcTemplate;
    private final BusinessAccessService accessService;

    @Autowired
    public TravelConfirmationController(TravelConfirmationService service,
                                        RegistrationWaitlistService registrationWaitlistService,
                                        AuditLogService auditLogService,
                                        JdbcTemplate jdbcTemplate,
                                        BusinessAccessService accessService) {
        setService(service);
        this.registrationWaitlistService = registrationWaitlistService;
        this.auditLogService = auditLogService;
        this.jdbcTemplate = jdbcTemplate;
        this.accessService = accessService;
    }

    @RequestMapping("/get_list")
    public Map<String, Object> getList(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "travel_confirmation"));
        Map<String, Object> map = service.selectToPage(service.readQuery(request), config);
        return success(map);
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put("like", "0");
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "travel_confirmation"));
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
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "travel_confirmation"));
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
            return error(30000, "请先登录后再提交行程确认");
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
        String validateMessage = registrationWaitlistService.validateTravelConfirmationAllowed(registrationId);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }
        String attendeeMessage = registrationWaitlistService.validateTravelAttendeesAllowed(
                registrationId, doubleValue(paramMap.get("number_of_attendees")));
        if (attendeeMessage != null) {
            return error(30000, attendeeMessage);
        }

        TravelConfirmation travelConfirmation = buildTravelConfirmation(paramMap, true);
        this.addEntity(travelConfirmation);
        auditLogService.record(request, intValue(paramMap.get("create_by")), "提交行程确认", "travel_confirmation",
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

        Integer travelConfirmationId = getTravelConfirmationId(queryMap, paramMap);
        ensureQueryId(queryMap, "travel_confirmation_id", travelConfirmationId);
        String auditExamineState = stringValue(paramMap.get("examine_state"));
        BusinessAccessService.Actor actor = accessService.currentActor(request);
        if (isAuditPayload(paramMap) && travelConfirmationId == null) {
            return error(30000, "行程确认ID不能为空");
        }
        if (travelConfirmationId != null && isAuditPayload(paramMap) && auditExamineState != null) {
            String permissionMessage = accessService.requireReviewAccess(
                    "travel_confirmation", "travel_confirmation_id", travelConfirmationId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
            String repeatMessage = validateAuditNotRepeated(travelConfirmationId);
            if (repeatMessage != null) {
                return error(30000, repeatMessage);
            }
        } else if (travelConfirmationId != null) {
            String permissionMessage = accessService.requireViewAccess(
                    "travel_confirmation", "travel_confirmation_id", travelConfirmationId, actor);
            if (permissionMessage != null) {
                return error(30000, permissionMessage);
            }
        }

        Integer registrationId = resolveRegistrationId(paramMap);
        if (registrationId == null && travelConfirmationId != null) {
            registrationId = getSourceRegistrationId(travelConfirmationId);
        }
        if (registrationId != null && paramMap.containsKey("number_of_attendees")) {
            String attendeeMessage = registrationWaitlistService.validateTravelAttendeesAllowed(
                    registrationId, doubleValue(paramMap.get("number_of_attendees")));
            if (attendeeMessage != null) {
                return error(30000, attendeeMessage);
            }
        }

        TravelConfirmation travelConfirmation = buildTravelConfirmation(paramMap, false);
        this.setEntity(queryMap, configMap, travelConfirmation);
        if (auditExamineState != null) {
            auditLogService.record(request, "审核行程确认", "travel_confirmation",
                    travelConfirmationId, "成功", auditExamineState);
        }
        return success(1);
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

    private TravelConfirmation buildTravelConfirmation(Map<String, Object> paramMap, boolean isAdd) {
        TravelConfirmation travelConfirmation = new TravelConfirmation();
        fillFromRegistration(paramMap);
        travelConfirmation.setOrder_number(stringValue(paramMap.get("order_number")));
        travelConfirmation.setBooth_number(stringValue(paramMap.get("booth_number")));
        travelConfirmation.setExhibitionconvention_number(stringValue(paramMap.get("exhibitionconvention_number")));
        travelConfirmation.setExhibition_theme(stringValue(paramMap.get("exhibition_theme")));
        travelConfirmation.setHost_user(intValue(paramMap.get("host_user")));
        travelConfirmation.setEnrolled_user(intValue(paramMap.get("enrolled_user")));
        travelConfirmation.setUser_name(stringValue(paramMap.get("user_name")));
        travelConfirmation.setUsers_mobile_phone(stringValue(paramMap.get("users_mobile_phone")));

        if (paramMap.get("confirm_time") != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("confirm_time")))) {
            travelConfirmation.setConfirm_time(parseToTimestamp(String.valueOf(paramMap.get("confirm_time"))));
        }

        travelConfirmation.setNumber_of_attendees(doubleValue(paramMap.get("number_of_attendees")));
        if (isAdd) {
            travelConfirmation.setExamine_state(defaultString(paramMap.get("examine_state"), RegistrationWaitlistService.EXAMINE_PENDING));
        } else if (paramMap.containsKey("examine_state")) {
            travelConfirmation.setExamine_state(stringValue(paramMap.get("examine_state")));
        }
        if (paramMap.containsKey("examine_reply")) {
            travelConfirmation.setExamine_reply(stringValue(paramMap.get("examine_reply")));
        }
        travelConfirmation.setExtra(stringValue(paramMap.get("extra")));
        travelConfirmation.setSource_table(stringValue(paramMap.get("source_table")));
        travelConfirmation.setSource_id(intValue(paramMap.get("source_id")));
        travelConfirmation.setSource_user_id(intValue(paramMap.get("source_user_id")));
        travelConfirmation.setCreate_by(intValue(paramMap.get("create_by")));
        return travelConfirmation;
    }

    private void fillFromRegistration(Map<String, Object> paramMap) {
        Integer registrationId = intValue(paramMap.get("source_id"));
        if (registrationId == null) {
            return;
        }
        Map<String, Object> registration = registrationWaitlistService.getRegistration(registrationId);
        if (registration == null) {
            return;
        }
        putIfMissing(paramMap, "order_number", registration.get("order_number"));
        putIfMissing(paramMap, "booth_number", registration.get("booth_number"));
        putIfMissing(paramMap, "exhibitionconvention_number", registration.get("exhibitionconvention_number"));
        putIfMissing(paramMap, "exhibition_theme", registration.get("exhibition_theme"));
        putIfMissing(paramMap, "host_user", registration.get("host_user"));
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
        java.util.List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id FROM registration_information WHERE IFNULL(is_deleted, 0) = 0 AND order_number = ? ORDER BY registration_information_id DESC LIMIT 1",
                orderNumber
        );
        return rows.isEmpty() ? null : intValue(rows.get(0).get("registration_information_id"));
    }

    private Integer getTravelConfirmationId(Map<String, String> queryMap, Map<String, Object> paramMap) {
        Object value = queryMap == null ? null : queryMap.get("travel_confirmation_id");
        if (value == null && queryMap != null) {
            value = queryMap.get("id");
        }
        if (value == null && paramMap != null) {
            value = paramMap.get("travel_confirmation_id");
        }
        if (value == null && paramMap != null) {
            value = paramMap.get("id");
        }
        return intValue(value);
    }

    private void ensureQueryId(Map<String, String> queryMap, String idColumn, Integer id) {
        if (queryMap != null && id != null && !queryMap.containsKey(idColumn) && !queryMap.containsKey("id")) {
            queryMap.put(idColumn, String.valueOf(id));
        }
    }

    private Integer getSourceRegistrationId(Integer travelConfirmationId) {
        if (travelConfirmationId == null) {
            return null;
        }
        java.util.List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT source_id FROM travel_confirmation WHERE IFNULL(is_deleted, 0) = 0 AND travel_confirmation_id = ? LIMIT 1",
                travelConfirmationId);
        return rows.isEmpty() ? null : intValue(rows.get(0).get("source_id"));
    }

    private boolean isAuditPayload(Map<String, Object> paramMap) {
        if (paramMap == null || !paramMap.containsKey("examine_state")) {
            return false;
        }
        for (String key : paramMap.keySet()) {
            if (!"examine_state".equals(key)
                    && !"examine_reply".equals(key)
                    && !"travel_confirmation_id".equals(key)
                    && !"id".equals(key)) {
                return false;
            }
        }
        return true;
    }

    private String validateAuditNotRepeated(Integer travelConfirmationId) {
        Map<String, String> queryMap = new java.util.HashMap<String, String>();
        queryMap.put("travel_confirmation_id", String.valueOf(travelConfirmationId));
        TravelConfirmation travelConfirmation = service.findOne(queryMap);
        if (travelConfirmation == null) {
            return "行程确认记录不存在";
        }
        String state = stringValue(travelConfirmation.getExamine_state());
        if (RegistrationWaitlistService.EXAMINE_APPROVED.equals(state)
                || RegistrationWaitlistService.EXAMINE_REJECTED.equals(state)) {
            return "当前行程确认已审核，请勿重复审核";
        }
        return null;
    }

    private String defaultString(Object rawValue, String defaultValue) {
        String value = stringValue(rawValue);
        return isBadValue(value) ? defaultValue : value;
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
