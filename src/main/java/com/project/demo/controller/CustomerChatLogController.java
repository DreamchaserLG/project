package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.CustomerChatLog;
import com.project.demo.service.CustomerChatLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/customer_chat_log")
public class CustomerChatLogController extends BaseController<CustomerChatLog, CustomerChatLogService> {

    @Autowired
    public CustomerChatLogController(CustomerChatLogService service) {
        setService(service);
    }
}
