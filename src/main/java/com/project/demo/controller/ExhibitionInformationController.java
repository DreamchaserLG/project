package com.project.demo.controller;

import com.project.demo.entity.ExhibitionInformation;
import com.project.demo.constant.FindConfig;
import com.project.demo.service.AuditLogService;
import com.project.demo.service.BusinessAccessService;
import com.project.demo.service.ExhibitionInformationService;
import com.alibaba.fastjson.JSON;
import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.util.StringUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import javax.persistence.Query;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 会展信息：(ExhibitionInformation)表控制层
 *
 */
@RestController
@RequestMapping("/exhibition_information")
public class ExhibitionInformationController extends BaseController<ExhibitionInformation, ExhibitionInformationService> {

    private final AuditLogService auditLogService;
    private final BusinessAccessService accessService;

    /**
     * 会展信息对象
     */
    @Autowired
    public ExhibitionInformationController(ExhibitionInformationService service,
                                           AuditLogService auditLogService,
                                           BusinessAccessService accessService) {
        setService(service);
        this.auditLogService = auditLogService;
        this.accessService = accessService;
    }

    @RequestMapping("/get_list")
    public Map<String, Object> getList(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "exhibition_information"));
        Map<String, Object> map = service.selectToPage(service.readQuery(request), config);
        return success(map);
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put("like", "0");
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "exhibition_information"));
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
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "exhibition_information"));
        Integer value = service.selectSqlToInteger(service.groupCount(service.readQuery(request), config));
        return success(value);
    }



    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap = service.readBody(request.getReader());
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).isEmpty();
        });
        String eventTime = normalizeEventTime(paramMap.get("event_time"));
        if (eventTime == null) {
            return error(30000, "会展结束时间必须至少晚于开始时间3小时");
        }
        paramMap.put("event_time", eventTime);
        ExhibitionInformation exhibition_information = new ExhibitionInformation();
            exhibition_information.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                            exhibition_information.setExhibition_theme(paramMap.get("exhibition_theme")==null?null:String.valueOf(paramMap.get("exhibition_theme")));
                            exhibition_information.setExhibition_and_convention_types(paramMap.get("exhibition_and_convention_types")==null?null:String.valueOf(paramMap.get("exhibition_and_convention_types")));
                            exhibition_information.setEvent_time(paramMap.get("event_time")==null?null:String.valueOf(paramMap.get("event_time")));
                            exhibition_information.setEvent_venue_name(paramMap.get("event_venue_name")==null?null:String.valueOf(paramMap.get("event_venue_name")));
                            exhibition_information.setExhibition_status(paramMap.get("exhibition_status")==null?null:String.valueOf(paramMap.get("exhibition_status")));
                            exhibition_information.setExhibition_poster(paramMap.get("exhibition_poster")==null?null:String.valueOf(paramMap.get("exhibition_poster")));
                            exhibition_information.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                            exhibition_information.setIntroduction_document(paramMap.get("introduction_document")==null?null:String.valueOf(paramMap.get("introduction_document")));
                            exhibition_information.setFee_standards(paramMap.get("fee_standards")==null?null:String.valueOf(paramMap.get("fee_standards")));
                            exhibition_information.setSchedule_t(paramMap.get("schedule_t")==null?null:String.valueOf(paramMap.get("schedule_t")));
                        exhibition_information.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        exhibition_information.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        exhibition_information.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        exhibition_information.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
        exhibition_information.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
                                                            exhibition_information.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(exhibition_information);
        auditLogService.record(request, paramMap.get("create_by") == null ? null : Integer.valueOf(String.valueOf(paramMap.get("create_by"))),
                "创建展会", "exhibition_information", null, "成功", exhibition_information.getExhibition_theme());
        System.out.println("会展信息新增成功");
        return success(1);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String,String> queryMap = service.readQuery(request);
        Map<String,String> configMap = service.readConfig(request);
        Map<String,Object> paramMap = service.readBody(request.getReader());
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).isEmpty();
        });
        if (paramMap.containsKey("event_time")) {
            String eventTime = normalizeEventTime(paramMap.get("event_time"));
            if (eventTime == null) {
                return error(30000, "会展结束时间必须至少晚于开始时间3小时");
            }
            paramMap.put("event_time", eventTime);
        }
        ExhibitionInformation exhibition_information = new ExhibitionInformation();
            exhibition_information.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                    exhibition_information.setExhibition_theme(paramMap.get("exhibition_theme")==null?null:String.valueOf(paramMap.get("exhibition_theme")));
                    exhibition_information.setExhibition_and_convention_types(paramMap.get("exhibition_and_convention_types")==null?null:String.valueOf(paramMap.get("exhibition_and_convention_types")));
                    exhibition_information.setEvent_time(paramMap.get("event_time")==null?null:String.valueOf(paramMap.get("event_time")));
                    exhibition_information.setEvent_venue_name(paramMap.get("event_venue_name")==null?null:String.valueOf(paramMap.get("event_venue_name")));
                    exhibition_information.setExhibition_status(paramMap.get("exhibition_status")==null?null:String.valueOf(paramMap.get("exhibition_status")));
                    exhibition_information.setExhibition_poster(paramMap.get("exhibition_poster")==null?null:String.valueOf(paramMap.get("exhibition_poster")));
                    exhibition_information.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                    exhibition_information.setIntroduction_document(paramMap.get("introduction_document")==null?null:String.valueOf(paramMap.get("introduction_document")));
                    exhibition_information.setFee_standards(paramMap.get("fee_standards")==null?null:String.valueOf(paramMap.get("fee_standards")));
                    exhibition_information.setSchedule_t(paramMap.get("schedule_t")==null?null:String.valueOf(paramMap.get("schedule_t")));
                exhibition_information.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        exhibition_information.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        exhibition_information.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        exhibition_information.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
        exhibition_information.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
        this.setEntity(queryMap,configMap,exhibition_information);
        auditLogService.record(request, "修改展会", "exhibition_information",
                queryMap.get("exhibition_information_id"), "成功", exhibition_information.getExhibition_theme());
        System.out.println("会展信息修改成功");
        return success(1);
    }

    private String normalizeEventTime(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        String value = String.valueOf(rawValue).trim();
        if (value.isEmpty() || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value)) {
            return null;
        }

        Pattern pattern = Pattern.compile("\\d{4}-\\d{2}-\\d{2}[ T]\\d{2}:\\d{2}(?::\\d{2})?");
        Matcher matcher = pattern.matcher(value);
        List<String> times = new ArrayList<String>();
        while (matcher.find()) {
            times.add(matcher.group().replace('T', ' '));
        }
        if (times.size() < 2) {
            return null;
        }

        LocalDateTime start = parseDateTime(times.get(0));
        LocalDateTime end = parseDateTime(times.get(1));
        if (start == null || end == null || end.isBefore(start.plusHours(3))) {
            return null;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return formatter.format(start) + " 至 " + formatter.format(end);
    }

    private LocalDateTime parseDateTime(String value) {
        try {
            String normalized = value.length() == 16 ? value + ":00" : value;
            return LocalDateTime.parse(normalized, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        } catch (Exception e) {
            return null;
        }
    }


    /**
     * 修改审核状态
     *
     * @param id          要修改的记录ID
     * @param newState    新的审核状态
     * @return 提示信息：审核成功/失败
     */
    @Transactional
    @GetMapping("/update_examine_state")
    public String updateExamineState(Long id, String newState) throws IOException {
        // 检查传入的状态是否合法
        if (!newState.equals("未审核") && !newState.equals("已通过") && !newState.equals("未通过")) {
            return "非法的审核状态";
        }

        Map<String,String> queryMap = new HashMap<>();
        queryMap.put("id",String.valueOf(id));
        // 根据ID查找记录
        ExhibitionInformation exhibition_information = service.findOne(queryMap);

        if (exhibition_information!=null) {
            // 更新审核状态
            exhibition_information.setExamine_state(newState);
            this.setEntity(queryMap,new HashMap<>(),exhibition_information);

            return "审核成功";
        } else {
            return "审核失败：记录不存在";
        }
    }
}
