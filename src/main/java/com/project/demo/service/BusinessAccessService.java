package com.project.demo.service;

import com.project.demo.entity.AccessToken;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BusinessAccessService {

    public static final String ROLE_ADMIN = "管理员";
    public static final String ROLE_HOST = "主办用户";
    public static final String ROLE_REGULAR = "普通用户";

    private final JdbcTemplate jdbcTemplate;
    private final RedisTemplate redisTemplate;

    public BusinessAccessService(JdbcTemplate jdbcTemplate, RedisTemplate redisTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.redisTemplate = redisTemplate;
    }

    public Actor currentActor(HttpServletRequest request) {
        Integer userId = userIdFromToken(request);
        if (userId == null || userId <= 0) {
            return Actor.guest();
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT user_id, username, nickname, user_group FROM user WHERE user_id = ? LIMIT 1",
                userId);
        if (rows.isEmpty()) {
            return Actor.guest();
        }

        Map<String, Object> row = rows.get(0);
        return new Actor(
                toInt(row.get("user_id")),
                safeString(row.get("username")),
                safeString(row.get("nickname")),
                safeString(row.get("user_group")));
    }

    public String scopedWhere(HttpServletRequest request) {
        return scopedWhere(currentActor(request));
    }

    public String scopedWhere(Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return "1 = 0";
        }
        if (actor.isAdmin()) {
            return "";
        }
        if (actor.isHost()) {
            return "host_user = " + actor.getUserId();
        }
        if (actor.isRegular()) {
            return "(enrolled_user = " + actor.getUserId()
                    + " OR source_user_id = " + actor.getUserId()
                    + " OR create_by = " + actor.getUserId() + ")";
        }
        return "1 = 0";
    }

    public String requireViewAccess(String table, String idColumn, Integer id, Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return "请先登录";
        }
        if (actor.isAdmin()) {
            return null;
        }
        Map<String, Object> row = findBusinessRow(table, idColumn, id);
        if (row == null) {
            return "记录不存在";
        }
        if (actor.isHost() && actor.getUserId().equals(toInt(row.get("host_user")))) {
            return null;
        }
        if (actor.isRegular()) {
            Integer userId = actor.getUserId();
            if (userId.equals(toInt(row.get("enrolled_user")))
                    || userId.equals(toInt(row.get("source_user_id")))
                    || userId.equals(toInt(row.get("create_by")))) {
                return null;
            }
        }
        return "无权访问该记录";
    }

    public String requireReviewAccess(String table, String idColumn, Integer id, Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return "请先登录后再审核";
        }
        if (actor.isAdmin()) {
            return null;
        }
        if (!actor.isHost()) {
            return "当前用户无审核权限";
        }

        Map<String, Object> row = findBusinessRow(table, idColumn, id);
        if (row == null) {
            return "记录不存在";
        }
        if (!actor.getUserId().equals(toInt(row.get("host_user")))) {
            return "只能审核当前主办方所属展会的数据";
        }
        return null;
    }

    public String requireRegistrationOwner(Integer registrationId, Actor actor) {
        if (actor == null || !actor.isLoggedIn()) {
            return "请先登录后再操作";
        }
        if (!actor.isRegular()) {
            return null;
        }
        Map<String, Object> row = findBusinessRow("registration_information", "registration_information_id", registrationId);
        if (row == null) {
            return "报名记录不存在";
        }
        Integer userId = actor.getUserId();
        if (userId.equals(toInt(row.get("enrolled_user")))
                || userId.equals(toInt(row.get("source_user_id")))
                || userId.equals(toInt(row.get("create_by")))) {
            return null;
        }
        return "只能操作自己的报名记录";
    }

    public Map<String, Object> findBusinessRow(String table, String idColumn, Integer id) {
        if (id == null || id <= 0 || !isAllowedBusinessTable(table) || !isAllowedIdColumn(idColumn)) {
            return null;
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT * FROM `" + table + "` WHERE `" + idColumn + "` = ? LIMIT 1",
                id);
        return rows.isEmpty() ? null : rows.get(0);
    }

    private Integer userIdFromToken(HttpServletRequest request) {
        String token = request == null ? "" : safeString(request.getHeader("x-auth-token"));
        if (token.isEmpty()) {
            return null;
        }

        try {
            Object cached = redisTemplate.opsForValue().get(token);
            if (cached instanceof AccessToken) {
                return ((AccessToken) cached).getUser_id();
            }
            if (cached instanceof Map) {
                Object value = ((Map<?, ?>) cached).get("user_id");
                if (value == null) {
                    value = ((Map<?, ?>) cached).get("userId");
                }
                Integer id = toInt(value);
                if (id != null) {
                    return id;
                }
            }
        } catch (Exception ignored) {
            // Redis is optional in this project; the database token table is the fallback.
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT user_id FROM access_token WHERE token = ? ORDER BY token_id DESC LIMIT 1",
                token);
        return rows.isEmpty() ? null : toInt(rows.get(0).get("user_id"));
    }

    private boolean isAllowedBusinessTable(String table) {
        return "registration_information".equals(table)
                || "travel_confirmation".equals(table)
                || "refund_request".equals(table);
    }

    private boolean isAllowedIdColumn(String idColumn) {
        return "registration_information_id".equals(idColumn)
                || "travel_confirmation_id".equals(idColumn)
                || "refund_request_id".equals(idColumn);
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

    public static class Actor {
        private final Integer userId;
        private final String username;
        private final String nickname;
        private final String userGroup;

        public Actor(Integer userId, String username, String nickname, String userGroup) {
            this.userId = userId == null ? 0 : userId;
            this.username = username == null ? "" : username;
            this.nickname = nickname == null ? "" : nickname;
            this.userGroup = userGroup == null ? "" : userGroup;
        }

        public static Actor guest() {
            return new Actor(0, "", "", "游客");
        }

        public Integer getUserId() {
            return userId;
        }

        public String getUsername() {
            return username;
        }

        public String getNickname() {
            return nickname;
        }

        public String getUserGroup() {
            return userGroup;
        }

        public boolean isLoggedIn() {
            return userId != null && userId > 0;
        }

        public boolean isAdmin() {
            return ROLE_ADMIN.equals(userGroup);
        }

        public boolean isHost() {
            return ROLE_HOST.equals(userGroup);
        }

        public boolean isRegular() {
            return ROLE_REGULAR.equals(userGroup);
        }
    }
}
