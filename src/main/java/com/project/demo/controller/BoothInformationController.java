package com.project.demo.controller;

import com.project.demo.entity.BoothInformation;
import com.project.demo.constant.FindConfig;
import com.project.demo.service.BusinessAccessService;
import com.project.demo.service.BoothInformationService;
import com.alibaba.fastjson.JSON;
import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
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


/**
 * 展位信息：(BoothInformation)表控制层
 *
 */
@RestController
@RequestMapping("/booth_information")
public class BoothInformationController extends BaseController<BoothInformation, BoothInformationService> {

    private final BusinessAccessService accessService;
    private final JdbcTemplate jdbcTemplate;

    /**
     * 展位信息对象
     */
    @Autowired
    public BoothInformationController(BoothInformationService service,
                                      BusinessAccessService accessService,
                                      JdbcTemplate jdbcTemplate) {
        setService(service);
        this.accessService = accessService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @RequestMapping("/get_list")
    public Map<String, Object> getList(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "booth_information"));
        Map<String, Object> map = service.selectToPage(service.readQuery(request), config);
        return success(map);
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        Map<String, String> config = service.readConfig(request);
        config.put("like", "0");
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "booth_information"));
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
        config.put(FindConfig.SQLHWERE, accessService.scopedWhere(request, "booth_information"));
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
        String validateMessage = validateBoothInput(paramMap);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }
        BoothInformation booth_information = new BoothInformation();
            booth_information.setBooth_number(paramMap.get("booth_number")==null?null:String.valueOf(paramMap.get("booth_number")));
                    Map<String, String> mapbooth_number = new HashMap<>();
        mapbooth_number.put("booth_number",String.valueOf(paramMap.get("booth_number")));
        List listbooth_number = service.selectBaseList(service.select(mapbooth_number, new HashMap<>()));
        if (listbooth_number.size()>0){
            return error(30000, "字段展位编号内容不能重复");
        }
                    booth_information.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                            booth_information.setExhibition_theme(paramMap.get("exhibition_theme")==null?null:String.valueOf(paramMap.get("exhibition_theme")));
                            booth_information.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                            booth_information.setBooth_name(paramMap.get("booth_name")==null?null:String.valueOf(paramMap.get("booth_name")));
                            booth_information.setBooth_type(paramMap.get("booth_type")==null?null:String.valueOf(paramMap.get("booth_type")));
                            booth_information.setBooth_location(paramMap.get("booth_location")==null?null:String.valueOf(paramMap.get("booth_location")));
                            booth_information.setBooth_prices(paramMap.get("booth_prices")==null?null:Double.valueOf(String.valueOf(paramMap.get("booth_prices"))));
                            booth_information.setBooth_specifications(paramMap.get("booth_specifications")==null?null:String.valueOf(paramMap.get("booth_specifications")));
                            booth_information.setBooth_images(paramMap.get("booth_images")==null?null:String.valueOf(paramMap.get("booth_images")));
                            booth_information.setBooth_specificss(paramMap.get("booth_specificss")==null?null:String.valueOf(paramMap.get("booth_specificss")));
                        booth_information.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        booth_information.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        booth_information.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        booth_information.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
        booth_information.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
            booth_information.setRegistration_information_limit_times(paramMap.get("registration_information_limit_times")==null?null:String.valueOf(paramMap.get("registration_information_limit_times")));
                                                                booth_information.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(booth_information);
        System.out.println("展位信息新增成功");
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
        String validateMessage = validateBoothInput(paramMap);
        if (validateMessage != null) {
            return error(30000, validateMessage);
        }
        BoothInformation booth_information = new BoothInformation();
            booth_information.setBooth_number(paramMap.get("booth_number")==null?null:String.valueOf(paramMap.get("booth_number")));
                    booth_information.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                    booth_information.setExhibition_theme(paramMap.get("exhibition_theme")==null?null:String.valueOf(paramMap.get("exhibition_theme")));
                    booth_information.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                    booth_information.setBooth_name(paramMap.get("booth_name")==null?null:String.valueOf(paramMap.get("booth_name")));
                    booth_information.setBooth_type(paramMap.get("booth_type")==null?null:String.valueOf(paramMap.get("booth_type")));
                    booth_information.setBooth_location(paramMap.get("booth_location")==null?null:String.valueOf(paramMap.get("booth_location")));
                    booth_information.setBooth_prices(paramMap.get("booth_prices")==null?null:Double.valueOf(String.valueOf(paramMap.get("booth_prices"))));
                    booth_information.setBooth_specifications(paramMap.get("booth_specifications")==null?null:String.valueOf(paramMap.get("booth_specifications")));
                    booth_information.setBooth_images(paramMap.get("booth_images")==null?null:String.valueOf(paramMap.get("booth_images")));
                    booth_information.setBooth_specificss(paramMap.get("booth_specificss")==null?null:String.valueOf(paramMap.get("booth_specificss")));
                booth_information.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        booth_information.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        booth_information.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        booth_information.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
        booth_information.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
            booth_information.setRegistration_information_limit_times(paramMap.get("registration_information_limit_times")==null?null:String.valueOf(paramMap.get("registration_information_limit_times")));
                        this.setEntity(queryMap,configMap,booth_information);
        System.out.println("展位信息修改成功");
        return success(1);
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
        BoothInformation booth_information = service.findOne(queryMap);

        if (booth_information!=null) {
            // 更新审核状态
            booth_information.setExamine_state(newState);
            this.setEntity(queryMap,new HashMap<>(),booth_information);

            return "审核成功";
        } else {
            return "审核失败：记录不存在";
        }
    }

    private String validateBoothInput(Map<String, Object> paramMap) {
        if (paramMap.containsKey("booth_prices")) {
            Double price = doubleValue(paramMap.get("booth_prices"));
            if (price == null || price <= 0) {
                return "展位价格必须大于0";
            }
        }
        if (paramMap.containsKey("registration_information_limit_times")) {
            Integer limit = intValue(paramMap.get("registration_information_limit_times"));
            if (limit == null || limit < 0) {
                return "报名限制次数不能小于0";
            }
        }
        String exhibitionNumber = stringValue(paramMap.get("exhibitionconvention_number"));
        if (exhibitionNumber != null) {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM exhibition_information WHERE IFNULL(is_deleted, 0) = 0 AND exhibitionconvention_number = ?",
                    Integer.class,
                    exhibitionNumber);
            if (count == null || count == 0) {
                return "关联会展不存在";
            }
        }
        return null;
    }

    private String stringValue(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        String value = String.valueOf(rawValue).trim();
        return value.isEmpty() || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value) ? null : value;
    }

    private Integer intValue(Object rawValue) {
        try {
            String value = stringValue(rawValue);
            return value == null ? null : Integer.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }

    private Double doubleValue(Object rawValue) {
        try {
            String value = stringValue(rawValue);
            return value == null ? null : Double.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
