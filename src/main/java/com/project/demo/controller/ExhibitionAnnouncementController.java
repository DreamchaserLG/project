package com.project.demo.controller;

import com.project.demo.entity.ExhibitionAnnouncement;
import com.project.demo.service.ExhibitionAnnouncementService;
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
 * 会展公告：(ExhibitionAnnouncement)表控制层
 *
 */
@RestController
@RequestMapping("/exhibition_announcement")
public class ExhibitionAnnouncementController extends BaseController<ExhibitionAnnouncement, ExhibitionAnnouncementService> {

    /**
     * 会展公告对象
     */
    @Autowired
    public ExhibitionAnnouncementController(ExhibitionAnnouncementService service) {
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
        ExhibitionAnnouncement exhibition_announcement = new ExhibitionAnnouncement();
            exhibition_announcement.setAnnouncement_title(paramMap.get("announcement_title")==null?null:String.valueOf(paramMap.get("announcement_title")));
                            exhibition_announcement.setAnnouncement_type(paramMap.get("announcement_type")==null?null:String.valueOf(paramMap.get("announcement_type")));
                            exhibition_announcement.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                            exhibition_announcement.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                            if (paramMap.get("release_time" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("release_time" )))) {
            String timStr = String.valueOf(paramMap.get("release_time" ));
            exhibition_announcement.setRelease_time(parseToTimestamp(timStr));
        } else {
            exhibition_announcement.setRelease_time(null);
        }
                            exhibition_announcement.setAnnouncement_image(paramMap.get("announcement_image")==null?null:String.valueOf(paramMap.get("announcement_image")));
                            exhibition_announcement.setAnnouncement_vuser_ideo(paramMap.get("announcement_vuser_ideo")==null?null:String.valueOf(paramMap.get("announcement_vuser_ideo")));
                            exhibition_announcement.setAnnouncement_content(paramMap.get("announcement_content")==null?null:String.valueOf(paramMap.get("announcement_content")));
                        exhibition_announcement.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        exhibition_announcement.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        exhibition_announcement.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        exhibition_announcement.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
                                                            exhibition_announcement.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(exhibition_announcement);
        System.out.println("会展公告新增成功");
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
        ExhibitionAnnouncement exhibition_announcement = new ExhibitionAnnouncement();
            exhibition_announcement.setAnnouncement_title(paramMap.get("announcement_title")==null?null:String.valueOf(paramMap.get("announcement_title")));
                    exhibition_announcement.setAnnouncement_type(paramMap.get("announcement_type")==null?null:String.valueOf(paramMap.get("announcement_type")));
                    exhibition_announcement.setExhibitionconvention_number(paramMap.get("exhibitionconvention_number")==null?null:String.valueOf(paramMap.get("exhibitionconvention_number")));
                    exhibition_announcement.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                    if (paramMap.get("release_time" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("release_time" )))) {
            String timStr = String.valueOf(paramMap.get("release_time" ));
            exhibition_announcement.setRelease_time(parseToTimestamp(timStr));
        } else {
            exhibition_announcement.setRelease_time(null);
        }
                    exhibition_announcement.setAnnouncement_image(paramMap.get("announcement_image")==null?null:String.valueOf(paramMap.get("announcement_image")));
                    exhibition_announcement.setAnnouncement_vuser_ideo(paramMap.get("announcement_vuser_ideo")==null?null:String.valueOf(paramMap.get("announcement_vuser_ideo")));
                    exhibition_announcement.setAnnouncement_content(paramMap.get("announcement_content")==null?null:String.valueOf(paramMap.get("announcement_content")));
                exhibition_announcement.setHits(paramMap.get("hits")==null?null:Integer.valueOf(String.valueOf(paramMap.get("hits"))));
        exhibition_announcement.setPraise_len(paramMap.get("praise_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("praise_len"))));
        exhibition_announcement.setCollect_len(paramMap.get("collect_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("collect_len"))));
        exhibition_announcement.setComment_len(paramMap.get("comment_len")==null?null:Integer.valueOf(String.valueOf(paramMap.get("comment_len"))));
                    this.setEntity(queryMap,configMap,exhibition_announcement);
        System.out.println("会展公告修改成功");
        return success(1);
    }


}
