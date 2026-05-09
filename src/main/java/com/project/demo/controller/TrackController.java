package com.project.demo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class TrackController {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public TrackController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
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
    public void track(@RequestBody Map<String, Object> body) {
        try {
            String event = str(body.get("event"));
            String page = str(body.get("page"));
            String userId = str(body.get("userId"));
            String username = str(body.get("username"));
            String dataJson = objectMapper.writeValueAsString(body.get("data"));

            jdbcTemplate.update(
                    "INSERT INTO user_track_log(event_name, page, data_json, user_id, username) " +
                            "VALUES (?, ?, ?, ?, ?)",
                    cut(event, 50),
                    cut(page, 500),
                    dataJson,
                    cut(userId, 100),
                    cut(username, 100)
            );
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
    public Object list(@RequestParam(required = false) String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";

            return jdbcTemplate.queryForList(
                    "SELECT id, event_name, page, data_json, user_id, username, create_time " +
                            "FROM user_track_log " +
                            "WHERE user_id LIKE ? OR username LIKE ? " +
                            "ORDER BY user_id ASC, id DESC " +
                            "LIMIT 200",
                    kw,
                    kw
            );
        }

        return jdbcTemplate.queryForList(
                "SELECT id, event_name, page, data_json, user_id, username, create_time " +
                        "FROM user_track_log " +
                        "ORDER BY user_id ASC, id DESC " +
                        "LIMIT 200"
        );
    }

    private String str(Object value) {
        if (value == null) return "";
        return String.valueOf(value);
    }

    private String cut(String value, int max) {
        if (value == null) return "";
        return value.length() > max ? value.substring(0, max) : value;
    }
}


