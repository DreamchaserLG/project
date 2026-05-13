package com.project.demo.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AuditLogService {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AuditLogService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void record(HttpServletRequest request,
                       Integer userId,
                       String actionType,
                       String objectType,
                       Object objectId,
                       String result,
                       String remark) {
        try {
            Map<String, Object> actor = findActor(userId, request);
            String actorId = safeString(actor.get("user_id"));
            String username = safeString(actor.get("username"));
            String role = safeString(actor.get("user_group"));
            String page = objectType == null || objectType.trim().isEmpty() ? "" : "/" + objectType;

            Map<String, Object> data = new HashMap<String, Object>();
            data.put("action_type", actionType);
            data.put("object_type", objectType);
            data.put("object_id", objectId);
            data.put("result", result);
            data.put("remark", remark);
            data.put("role", role);
            data.put("ip", clientIp(request));

            String dataJson = objectMapper.writeValueAsString(data);
            try {
                jdbcTemplate.update(
                        "INSERT INTO user_track_log(event_name, page, data_json, user_id, username, user_role, action_type, object_type, object_id, ip, result, remark, create_time) "
                                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())",
                        safeCut(actionType, 50),
                        safeCut(page, 500),
                        dataJson,
                        safeCut(actorId, 100),
                        safeCut(username, 100),
                        safeCut(role, 50),
                        safeCut(actionType, 50),
                        safeCut(objectType, 100),
                        objectId == null ? null : safeCut(String.valueOf(objectId), 100),
                        safeCut(clientIp(request), 64),
                        safeCut(result, 50),
                        safeCut(remark, 500)
                );
            } catch (Exception ignored) {
                jdbcTemplate.update(
                        "INSERT INTO user_track_log(event_name, page, data_json, user_id, username, create_time) "
                                + "VALUES (?, ?, ?, ?, ?, NOW())",
                        safeCut(actionType, 50),
                        safeCut(page, 500),
                        dataJson,
                        safeCut(actorId, 100),
                        safeCut(username, 100)
                );
            }
        } catch (Exception ignored) {
            // 审计日志不能影响主业务。
        }
    }

    public void record(HttpServletRequest request,
                       String actionType,
                       String objectType,
                       Object objectId,
                       String result,
                       String remark) {
        record(request, null, actionType, objectType, objectId, result, remark);
    }

    private Map<String, Object> findActor(Integer userId, HttpServletRequest request) {
        Integer actorId = userId;
        if ((actorId == null || actorId <= 0) && request != null) {
            String token = request.getHeader("x-auth-token");
            if (!safeString(token).isEmpty()) {
                List<Map<String, Object>> tokenRows = jdbcTemplate.queryForList(
                        "SELECT user_id FROM access_token WHERE token = ? ORDER BY token_id DESC LIMIT 1",
                        token
                );
                if (!tokenRows.isEmpty()) {
                    actorId = toInt(tokenRows.get(0).get("user_id"));
                }
            }
        }

        if (actorId != null && actorId > 0) {
            List<Map<String, Object>> userRows = jdbcTemplate.queryForList(
                    "SELECT user_id, username, nickname, user_group FROM user WHERE user_id = ? LIMIT 1",
                    actorId
            );
            if (!userRows.isEmpty()) {
                return userRows.get(0);
            }
        }

        Map<String, Object> anonymous = new HashMap<String, Object>();
        anonymous.put("user_id", actorId == null ? "" : actorId);
        anonymous.put("username", "");
        anonymous.put("user_group", "");
        return anonymous;
    }

    private String clientIp(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        String forwarded = request.getHeader("X-Forwarded-For");
        if (!safeString(forwarded).isEmpty()) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (!safeString(realIp).isEmpty()) {
            return realIp;
        }
        return request.getRemoteAddr();
    }

    private String safeCut(String value, int max) {
        String text = safeString(value);
        return text.length() > max ? text.substring(0, max) : text;
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
        try {
            String value = safeString(rawValue);
            return value.isEmpty() ? null : Integer.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
