package com.project.demo.controller;

import com.alibaba.fastjson.JSON;
import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.CustomerChatGroup;
import com.project.demo.service.CustomerChatGroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/customer_chat_group")
public class CustomerChatGroupController extends BaseController<CustomerChatGroup, CustomerChatGroupService> {

    @Autowired
    public CustomerChatGroupController(CustomerChatGroupService service) {
        setService(service);
    }

    @Override
    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = service.readBody(request.getReader());
        CustomerChatGroup entity = JSON.parseObject(JSON.toJSONString(paramMap), CustomerChatGroup.class);
        if (entity.getUnread_count() == null) {
            entity.setUnread_count(0);
        }
        service.insert(entity);
        return success(entity.getCustomer_chat_group_id());
    }
}
