package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.TravelConfirmation;
import com.project.demo.service.TravelConfirmationService;
import com.project.demo.service.RegistrationWaitlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/travel_confirmation")
public class TravelConfirmationController extends BaseController<TravelConfirmation, TravelConfirmationService> {

    private final RegistrationWaitlistService registrationWaitlistService;

    @Autowired
    public TravelConfirmationController(TravelConfirmationService service,
                                        RegistrationWaitlistService registrationWaitlistService) {
        setService(service);
        this.registrationWaitlistService = registrationWaitlistService;
    }

    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);

        Integer registrationId = intValue(paramMap.get("source_id"));
        String validateMessage = registrationWaitlistService.validateTravelConfirmationAllowed(registrationId);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }

        TravelConfirmation travelConfirmation = buildTravelConfirmation(paramMap);
        this.addEntity(travelConfirmation);
        return success(1);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String, String> queryMap = service.readQuery(request);
        Map<String, String> configMap = service.readConfig(request);
        Map<String, Object> paramMap = service.readBody(request.getReader());
        clearEmptyString(paramMap);

        TravelConfirmation travelConfirmation = buildTravelConfirmation(paramMap);
        this.setEntity(queryMap, configMap, travelConfirmation);
        return success(1);
    }

    private TravelConfirmation buildTravelConfirmation(Map<String, Object> paramMap) {
        TravelConfirmation travelConfirmation = new TravelConfirmation();
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
        travelConfirmation.setExtra(stringValue(paramMap.get("extra")));
        travelConfirmation.setSource_table(stringValue(paramMap.get("source_table")));
        travelConfirmation.setSource_id(intValue(paramMap.get("source_id")));
        travelConfirmation.setSource_user_id(intValue(paramMap.get("source_user_id")));
        travelConfirmation.setCreate_by(intValue(paramMap.get("create_by")));
        return travelConfirmation;
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
