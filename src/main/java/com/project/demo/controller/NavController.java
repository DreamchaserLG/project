package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.Nav;
import com.project.demo.service.NavService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/nav")
public class NavController extends BaseController<Nav, NavService> {

    @Autowired
    public NavController(NavService service) {
        setService(service);
    }
}
