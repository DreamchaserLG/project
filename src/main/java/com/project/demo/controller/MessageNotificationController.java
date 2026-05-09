package com.project.demo.controller;

import com.project.demo.entity.MessageNotification;
import com.project.demo.service.MessageNotificationService;
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
 * 消息通知：(MessageNotification)表控制层
 *
 */
@RestController
@RequestMapping("/message_notification")
public class MessageNotificationController extends BaseController<MessageNotification, MessageNotificationService> {

    /**
     * 消息通知对象
     */
    @Autowired
    public MessageNotificationController(MessageNotificationService service) {
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
        MessageNotification message_notification = new MessageNotification();
            message_notification.setNotice_number(paramMap.get("notice_number")==null?null:String.valueOf(paramMap.get("notice_number")));
                            message_notification.setNotice_title(paramMap.get("notice_title")==null?null:String.valueOf(paramMap.get("notice_title")));
                            if (paramMap.get("notification_time" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("notification_time" )))) {
            String timStr = String.valueOf(paramMap.get("notification_time" ));
            message_notification.setNotification_time(parseToTimestamp(timStr));
        } else {
            message_notification.setNotification_time(null);
        }
                            message_notification.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                            message_notification.setRegular_user(paramMap.get("regular_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("regular_user"))));
                            message_notification.setNotice_content(paramMap.get("notice_content")==null?null:String.valueOf(paramMap.get("notice_content")));
                            message_notification.setMark_status(paramMap.get("mark_status")==null?null:String.valueOf(paramMap.get("mark_status")));
                                                                            message_notification.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(message_notification);
        System.out.println("消息通知新增成功");
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
        MessageNotification message_notification = new MessageNotification();
            message_notification.setNotice_number(paramMap.get("notice_number")==null?null:String.valueOf(paramMap.get("notice_number")));
                    message_notification.setNotice_title(paramMap.get("notice_title")==null?null:String.valueOf(paramMap.get("notice_title")));
                    if (paramMap.get("notification_time" ) != null && !StringUtils.isEmpty(String.valueOf(paramMap.get("notification_time" )))) {
            String timStr = String.valueOf(paramMap.get("notification_time" ));
            message_notification.setNotification_time(parseToTimestamp(timStr));
        } else {
            message_notification.setNotification_time(null);
        }
                    message_notification.setHost_user(paramMap.get("host_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("host_user"))));
                    message_notification.setRegular_user(paramMap.get("regular_user")==null?null:Integer.valueOf(String.valueOf(paramMap.get("regular_user"))));
                    message_notification.setNotice_content(paramMap.get("notice_content")==null?null:String.valueOf(paramMap.get("notice_content")));
                    message_notification.setMark_status(paramMap.get("mark_status")==null?null:String.valueOf(paramMap.get("mark_status")));
                            this.setEntity(queryMap,configMap,message_notification);
        System.out.println("消息通知修改成功");
        return success(1);
    }


}
