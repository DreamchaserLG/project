package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.ReleasingNotices;
import com.project.demo.service.ReleasingNoticesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/releasing_notices")
public class ReleasingNoticesController extends BaseController<ReleasingNotices, ReleasingNoticesService> {

    @Autowired
    public ReleasingNoticesController(ReleasingNoticesService service) {
        setService(service);
    }
}
