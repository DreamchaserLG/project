package com.project.demo.controller;

import com.project.demo.service.RegistrationWaitlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/registration/waitlist")
public class RegistrationWaitlistController {

    private final RegistrationWaitlistService registrationWaitlistService;

    @Autowired
    public RegistrationWaitlistController(RegistrationWaitlistService registrationWaitlistService) {
        this.registrationWaitlistService = registrationWaitlistService;
    }

    @PostMapping("/apply")
    @Transactional
    public Map<String, Object> apply(@RequestBody Map<String, Object> body) {
        Map<String, Object> result = registrationWaitlistService.createBoothRegistration(body);
        if (!isOk(result)) {
            return error(result);
        }
        return success(result);
    }

    @PostMapping("/cancel/{registrationId}")
    @Transactional
    public Map<String, Object> cancel(@PathVariable Integer registrationId) {
        Map<String, Object> result = registrationWaitlistService.cancelRegistration(
                registrationId,
                "取消报名",
                ""
        );
        if (!isOk(result)) {
            return error(result);
        }
        return success(result);
    }

    @PostMapping("/audit-reject/{registrationId}")
    @Transactional
    public Map<String, Object> auditReject(@PathVariable Integer registrationId,
                                           @RequestBody(required = false) Map<String, Object> body) {
        String examineReply = "";
        if (body != null && body.get("examine_reply") != null) {
            examineReply = String.valueOf(body.get("examine_reply"));
        }

        Map<String, Object> result = registrationWaitlistService.cancelRegistration(
                registrationId,
                "审核未通过",
                examineReply
        );
        if (!isOk(result)) {
            return error(result);
        }
        return success(result);
    }

    @PostMapping("/refund-pass/{registrationId}")
    @Transactional
    public Map<String, Object> refundPass(@PathVariable Integer registrationId) {
        Map<String, Object> result = registrationWaitlistService.cancelRegistration(
                registrationId,
                "退款通过",
                ""
        );
        if (!isOk(result)) {
            return error(result);
        }
        return success(result);
    }

    @GetMapping("/status")
    @Transactional
    public Map<String, Object> status(@RequestParam Integer boothId,
                                      @RequestParam(required = false) Integer userId) {
        Map<String, Object> result = registrationWaitlistService.boothStatus(boothId, userId);
        if (!isOk(result)) {
            return error(result);
        }
        return success(result);
    }

    @GetMapping("/list")
    @Transactional
    public Map<String, Object> list(@RequestParam Integer boothId) {
        List<Map<String, Object>> list = registrationWaitlistService.boothQueue(boothId);
        return success(list);
    }

    private boolean isOk(Map<String, Object> result) {
        return result != null && Boolean.TRUE.equals(result.get("ok"));
    }

    private Map<String, Object> success(Object result) {
        Map<String, Object> response = new HashMap<String, Object>();
        response.put("result", result);
        return response;
    }

    private Map<String, Object> error(Map<String, Object> result) {
        Map<String, Object> response = new HashMap<String, Object>();
        Map<String, Object> error = new HashMap<String, Object>();
        error.put("code", 30000);
        error.put("message", result == null ? "处理失败" : String.valueOf(result.get("message")));
        response.put("error", error);
        return response;
    }
}
