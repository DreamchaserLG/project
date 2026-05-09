package com.project.demo.controller;

import com.project.demo.entity.MessageInform;
import com.project.demo.service.MessageInformService;
import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

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
 * 通知记录：(MessageInform)表控制层
 *
 */
@RestController
@RequestMapping("/message_inform")
public class MessageInformController extends BaseController<MessageInform, MessageInformService> {

    /**
     * 通知记录对象
     */
    @Autowired
    public MessageInformController(MessageInformService service) {
        setService(service);
    }



    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap = service.readBody(request.getReader());
        this.addMap(paramMap);
        return success(1);
    }


}
