package com.project.demo.service;

import com.project.demo.entity.AccessToken;
import com.project.demo.constant.LogicalDeleteConfig;
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

    public String scopedWhere(HttpServletRequest request, String table) {
        return scopedWhere(table, currentActor(request));
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

    public String scopedWhere(String table, Actor actor) {
        String visibleWhere = visibleBusinessWhere(table);
        if (actor == null || !actor.isLoggedIn()) {
            return "1 = 0";
        }
        if (actor.isAdmin()) {
            return visibleWhere;
        }
        if (actor.isRegular()) {
            if ("exhibition_information".equals(table) || "booth_information".equals(table)) {
                return visibleWhere;
            }
            return combineWhere(visibleWhere, scopedWhere(actor));
        }
        if (!actor.isHost()) {
            return "1 = 0";
        }

        Integer userId = actor.getUserId();
        if ("exhibition_information".equals(table)) {
            return combineWhere(visibleWhere, "host_user = " + userId);
        }
        if ("booth_information".equals(table)) {
            return combineWhere(visibleWhere, boothHostWhere(userId));
        }
        if ("registration_information".equals(table)) {
            return combineWhere(visibleWhere, registrationHostWhere(userId));
        }
        if ("travel_confirmation".equals(table)) {
            return combineWhere(visibleWhere, linkedToRegistrationHostWhere(userId));
        }
        if ("refund_request".equals(table)) {
            return combineWhere(visibleWhere, linkedToRegistrationHostWhere(userId));
        }
        return combineWhere(visibleWhere, "host_user = " + userId);
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
        if (actor.isHost() && hasHostAccess(table, idColumn, id, actor)) {
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
        if (!hasHostAccess(table, idColumn, id, actor)) {
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
                "SELECT * FROM `" + table + "` WHERE `" + idColumn + "` = ? "
                        + "AND (" + visibleBusinessWhere(table) + ") LIMIT 1",
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
                || "refund_request".equals(table)
                || "exhibition_information".equals(table)
                || "booth_information".equals(table);
    }

    private String visibleBusinessWhere(String table) {
        if (LogicalDeleteConfig.hasLogicalDelete(table)) {
            return LogicalDeleteConfig.visibleWhere();
        }
        return "";
    }

    private String combineWhere(String left, String right) {
        String l = safeString(left);
        String r = safeString(right);
        if (l.isEmpty()) {
            return r;
        }
        if (r.isEmpty()) {
            return l;
        }
        return "(" + l + ") AND (" + r + ")";
    }

    private boolean isAllowedIdColumn(String idColumn) {
        return "registration_information_id".equals(idColumn)
                || "travel_confirmation_id".equals(idColumn)
                || "refund_request_id".equals(idColumn)
                || "exhibition_information_id".equals(idColumn)
                || "booth_information_id".equals(idColumn);
    }

    private boolean hasHostAccess(String table, String idColumn, Integer id, Actor actor) {
        if (actor == null || !actor.isHost() || id == null || id <= 0
                || !isAllowedBusinessTable(table) || !isAllowedIdColumn(idColumn)) {
            return false;
        }
        String where = scopedWhere(table, actor);
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM `" + table + "` WHERE `" + idColumn + "` = ? AND (" + where + ")",
                Integer.class,
                id);
        return count != null && count > 0;
    }

    private String boothHostWhere(Integer userId) {
        String exhibitionScope = "SELECT exhibitionconvention_number FROM exhibition_information WHERE IFNULL(is_deleted, 0) = 0 AND host_user = " + userId;
        return "(host_user = " + userId
                + " OR exhibitionconvention_number IN (" + exhibitionScope + "))";
    }

    private String registrationHostWhere(Integer userId) {
        String exhibitionScope = "SELECT exhibitionconvention_number FROM exhibition_information WHERE IFNULL(is_deleted, 0) = 0 AND host_user = " + userId;
        String boothScope = "SELECT booth_number FROM booth_information WHERE IFNULL(is_deleted, 0) = 0 AND " + boothHostWhere(userId);
        return "(host_user = " + userId
                + " OR exhibitionconvention_number IN (" + exhibitionScope + ")"
                + " OR booth_number IN (" + boothScope + "))";
    }

    private String linkedToRegistrationHostWhere(Integer userId) {
        String registrationScope = registrationHostWhere(userId);
        return "(host_user = " + userId
                + " OR source_id IN (SELECT registration_information_id FROM registration_information WHERE IFNULL(is_deleted, 0) = 0 AND " + registrationScope + ")"
                + " OR order_number IN (SELECT order_number FROM registration_information WHERE IFNULL(is_deleted, 0) = 0 AND " + registrationScope + "))";
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
