package com.project.demo.controller;

import com.project.demo.entity.DataStatistics;
import com.project.demo.service.BusinessAccessService;
import com.project.demo.service.DataStatisticsService;
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


/**
 * 数据统计：(DataStatistics)表控制层
 *
 */
@RestController
@RequestMapping("/data_statistics")
public class DataStatisticsController extends BaseController<DataStatistics, DataStatisticsService> {

    private final BusinessAccessService accessService;

    /**
     * 数据统计对象
     */
    @Autowired
    public DataStatisticsController(DataStatisticsService service, BusinessAccessService accessService) {
        setService(service);
        this.accessService = accessService;
    }

    @RequestMapping("/get_list")
    public Map<String, Object> getList(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return success(service.businessStatisticsPage(service.readQuery(request)));
    }

    @RequestMapping("/business_overview")
    public Map<String, Object> businessOverview(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return success(service.businessOverview());
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.obj(request);
    }

    @RequestMapping(value = {"/count_group", "/count"})
    public Map<String, Object> count(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.count(request);
    }

    @RequestMapping(value = {"/sum_group", "/sum"})
    public Map<String, Object> sum(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.sum(request);
    }

    @RequestMapping(value = {"/avg_group", "/avg"})
    public Map<String, Object> avg(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.avg(request);
    }

    @RequestMapping("/list_group")
    public Map<String, Object> listGroup(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.listGroup(request);
    }

    @RequestMapping("/bar_group")
    public Map<String, Object> barGroup(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.barGroup(request);
    }

    @RequestMapping(value = "/del")
    @Transactional
    public Map<String, Object> del(HttpServletRequest request) {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        return super.del(request);
    }



    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        Map<String,Object> paramMap = service.readBody(request.getReader());
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).isEmpty();
        });
        DataStatistics data_statistics = new DataStatistics();
            data_statistics.setStatistics_number(paramMap.get("statistics_number")==null?null:String.valueOf(paramMap.get("statistics_number")));
                            data_statistics.setStatistics_type(paramMap.get("statistics_type")==null?null:String.valueOf(paramMap.get("statistics_type")));
                            data_statistics.setStatistical_indicators(paramMap.get("statistical_indicators")==null?null:String.valueOf(paramMap.get("statistical_indicators")));
                            String metricError = validateTypeIndicator(data_statistics.getStatistics_type(), data_statistics.getStatistical_indicators());
        if (metricError != null) {
            return error(30000, metricError);
        }
                            if (paramMap.get("statistics_date" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("statistics_date" )))) {
            String timStr = String.valueOf(paramMap.get("statistics_date" ));
            data_statistics.setStatistics_date(parseToTimestamp(timStr));
        } else {
            data_statistics.setStatistics_date(new java.sql.Timestamp(System.currentTimeMillis()));
        }
                            data_statistics.setStatistical_results(service.calculateMetric(data_statistics.getStatistics_type(), data_statistics.getStatistical_indicators()));
                            data_statistics.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                                                                            data_statistics.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(data_statistics);
        recordAudit(request, "新增", "成功", "数据统计");
        System.out.println("数据统计新增成功");
        return success(1);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String, Object> blocked = requireAdmin(request);
        if (blocked != null) {
            return blocked;
        }
        Map<String,String> queryMap = service.readQuery(request);
        Map<String,String> configMap = service.readConfig(request);
        Map<String,Object> paramMap = service.readBody(request.getReader());
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).isEmpty();
        });
        DataStatistics data_statistics = new DataStatistics();
            data_statistics.setStatistics_number(paramMap.get("statistics_number")==null?null:String.valueOf(paramMap.get("statistics_number")));
                    data_statistics.setStatistics_type(paramMap.get("statistics_type")==null?null:String.valueOf(paramMap.get("statistics_type")));
                    data_statistics.setStatistical_indicators(paramMap.get("statistical_indicators")==null?null:String.valueOf(paramMap.get("statistical_indicators")));
                    if (data_statistics.getStatistics_type() != null || data_statistics.getStatistical_indicators() != null) {
            String metricError = validateTypeIndicator(data_statistics.getStatistics_type(), data_statistics.getStatistical_indicators());
            if (metricError != null) {
                return error(30000, metricError);
            }
        }
                    if (paramMap.get("statistics_date" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("statistics_date" )))) {
            String timStr = String.valueOf(paramMap.get("statistics_date" ));
            data_statistics.setStatistics_date(parseToTimestamp(timStr));
        } else {
            data_statistics.setStatistics_date(null);
        }
                    data_statistics.setStatistical_results(service.calculateMetric(data_statistics.getStatistics_type(), data_statistics.getStatistical_indicators()));
                    data_statistics.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                            this.setEntity(queryMap,configMap,data_statistics);
        recordAudit(request, "修改", "成功", "数据统计");
        System.out.println("数据统计修改成功");
        return success(1);
    }

    private Map<String, Object> requireAdmin(HttpServletRequest request) {
        if (accessService.currentActor(request).isAdmin()) {
            return null;
        }
        return error(30000, "数据统计模块仅管理员可访问");
    }

    private String validateTypeIndicator(String statisticsType, String indicator) {
        if (!service.isValidTypeIndicator(statisticsType, indicator)) {
            return "统计类型与统计指标不匹配：报名统计仅支持报名人数、候补人数、审核通过人数；财务统计仅支持成交额、退款金额、实际收入；行程统计仅支持行程确认人数、到场人数";
        }
        return null;
    }

}
