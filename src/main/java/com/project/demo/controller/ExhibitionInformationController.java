package com.project.demo.controller;

import com.project.demo.entity.ExhibitionInformation;
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


/**
 * 会展信息：(ExhibitionInformation)表控制层
 *
 */
@RestController
@RequestMapping("/exhibition_information")
public class ExhibitionInformationController extends BaseController<ExhibitionInformation, ExhibitionInformationService> {

    /**
     * 会展信息对象
     */
    @Autowired
    public ExhibitionInformationController(ExhibitionInformationService service) {
        setService(service);
    }



    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap = service.readBody(request.getReader());
        paramMap.entrySet().removeIf(entry -> {
            Object value = entry.getValue();
            return value instanceof String && ((String) value).isEmpty();
        });
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
        System.out.println("会展信息修改成功");
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
