package com.project.demo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.demo.service.BusinessAccessService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class TrackController {

    private final JdbcTemplate jdbcTemplate;
    private final BusinessAccessService accessService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public TrackController(JdbcTemplate jdbcTemplate, BusinessAccessService accessService) {
        this.jdbcTemplate = jdbcTemplate;
        this.accessService = accessService;
    }

    /**
     * 保存用户追踪记录
     *
     * 你的 yml 里配置了：
     * server.servlet.context-path=/api
     *
     * 所以前端访问地址是：
     * POST /api/track
     *
     * 这里不要写 /api/track，只写 /track
     */
    @PostMapping("/track")
    public void track(@RequestBody Map<String, Object> body, HttpServletRequest request) {
        try {
            String event = str(body.get("event"));
            String page = str(body.get("page"));
            String userId = str(body.get("userId"));
            String username = str(body.get("username"));
            String userRole = str(body.get("userRole"));
            String dataJson = objectMapper.writeValueAsString(body.get("data"));

            try {
                jdbcTemplate.update(
                        "INSERT INTO user_track_log(event_name, page, data_json, user_id, username, user_role, action_type, object_type, ip, result, remark, create_time) "
                                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())",
                        cut(event, 50),
                        cut(page, 500),
                        dataJson,
                        cut(userId, 100),
                        cut(username, 100),
                        cut(userRole, 50),
                        cut(event, 50),
                        cut(page, 100),
                        cut(clientIp(request), 64),
                        "成功",
                        ""
                );
            } catch (Exception ignored) {
                jdbcTemplate.update(
                        "INSERT INTO user_track_log(event_name, page, data_json, user_id, username) " +
                                "VALUES (?, ?, ?, ?, ?)",
                        cut(event, 50),
                        cut(page, 500),
                        dataJson,
                        cut(userId, 100),
                        cut(username, 100)
                );
            }
        } catch (Exception e) {
            // 追踪失败不要影响正常业务
            e.printStackTrace();
        }
    }

    /**
     * 查询用户追踪记录
     *
     * 外部访问：
     * GET /api/track/list
     *
     * 支持：
     * /api/track/list
     * /api/track/list?keyword=张三
     * /api/track/list?keyword=1
     */
    @GetMapping("/track/list")
    public Map<String, Object> list(@RequestParam(required = false) String keyword,
                                    @RequestParam(required = false) String user_id,
                                    @RequestParam(required = false) String username,
                                    @RequestParam(required = false) String user_role,
                                    @RequestParam(required = false) String action_type,
                                    @RequestParam(required = false) String start_time,
                                    @RequestParam(required = false) String end_time,
                                    @RequestParam(required = false, defaultValue = "1") Integer page,
                                    @RequestParam(required = false, defaultValue = "20") Integer size,
                                    HttpServletRequest request) {
        if (!accessService.currentActor(request).isAdmin()) {
            Map<String, Object> wrapper = new HashMap<>();
            Map<String, Object> error = new HashMap<>();
            error.put("code", 30000);
            error.put("message", "仅管理员可查看审计日志");
            wrapper.put("error", error);
            return wrapper;
        }
        StringBuilder where = new StringBuilder(" FROM user_track_log WHERE 1 = 1 ");
        List<Object> args = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            where.append("AND (user_id LIKE ? OR username LIKE ? OR event_name LIKE ? OR page LIKE ? OR remark LIKE ? OR object_type LIKE ? OR object_id LIKE ?) ");
            args.add(kw);
            args.add(kw);
            args.add(kw);
            args.add(kw);
            args.add(kw);
            args.add(kw);
            args.add(kw);
        }
        if (user_id != null && !user_id.trim().isEmpty()) {
            where.append("AND user_id = ? ");
            args.add(user_id.trim());
        }
        if (username != null && !username.trim().isEmpty()) {
            where.append("AND username LIKE ? ");
            args.add("%" + username.trim() + "%");
        }
        if (user_role != null && !user_role.trim().isEmpty()) {
            where.append("AND user_role = ? ");
            args.add(user_role.trim());
        }
        if (action_type != null && !action_type.trim().isEmpty()) {
            where.append("AND action_type = ? ");
            args.add(action_type.trim());
        }
        if (start_time != null && !start_time.trim().isEmpty()) {
            where.append("AND create_time >= ? ");
            args.add(start_time.trim());
        }
        if (end_time != null && !end_time.trim().isEmpty()) {
            where.append("AND create_time <= ? ");
            args.add(end_time.trim());
        }
        int pageNo = page == null || page < 1 ? 1 : page;
        int pageSize = size == null || size < 1 ? 20 : Math.min(size, 100);
        String countSql = "SELECT COUNT(*)" + where;
        Number count = jdbcTemplate.queryForObject(countSql, args.toArray(), Number.class);
        StringBuilder sql = new StringBuilder(
                "SELECT id, event_name, page, data_json, user_id, username, user_role, action_type, object_type, object_id, ip, result, remark, create_time ");
        sql.append(where);
        sql.append("ORDER BY id DESC LIMIT ? OFFSET ?");
        List<Object> pageArgs = new ArrayList<>(args);
        pageArgs.add(pageSize);
        pageArgs.add((pageNo - 1) * pageSize);

        Map<String, Object> result = new HashMap<>();
        result.put("list", jdbcTemplate.queryForList(sql.toString(), pageArgs.toArray()));
        result.put("count", count == null ? 0 : count);

        Map<String, Object> wrapper = new HashMap<>();
        wrapper.put("result", result);
        return wrapper;
    }

    private String str(Object value) {
        if (value == null) return "";
        return String.valueOf(value);
    }

    private String cut(String value, int max) {
        if (value == null) return "";
        return value.length() > max ? value.substring(0, max) : value;
    }

    private String clientIp(HttpServletRequest request) {
        if (request == null) return "";
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.trim().isEmpty()) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        return realIp != null && !realIp.trim().isEmpty() ? realIp : request.getRemoteAddr();
    }
}


