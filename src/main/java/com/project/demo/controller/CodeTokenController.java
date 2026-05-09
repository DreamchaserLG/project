package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.CodeToken;
import com.project.demo.service.CodeTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("code_token")
public class CodeTokenController extends BaseController<CodeToken, CodeTokenService> {

    @Autowired
    public CodeTokenController(CodeTokenService service) {
        setService(service);
    }

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.mail.from:}")
    private String mailFrom;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    @GetMapping("send_email")
    public Map<String, Object> sendEmail(String email) {
        if (!StringUtils.hasText(email)) {
            return error(30000, "invalid email");
        }

        String sender = StringUtils.hasText(mailFrom) ? mailFrom : mailUsername;
        if (!StringUtils.hasText(sender)) {
            return error(30000, "mail sender is not configured");
        }

        try {
            int code = (int) (Math.floor(Math.random() * 900000) + 100000);

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
            helper.setFrom(sender);
            helper.setTo(email);
            helper.setSubject("Reset Password");
            helper.setText("<h1>Verification code: " + code + "</h1>", true);
            mailSender.send(mimeMessage);

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.MINUTE, 10);
            String token = service.encryption(code + "_" + cal.getTime());
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Map<String, Object> map = new HashMap<>();
            map.put("token", token);
            map.put("code", code);
            map.put("expire_time", format.format(cal.getTime()));
            this.addMap(map);

            Map<String, Object> result = new HashMap<>();
            result.put("result", 1);
            result.put("token", token);
            return result;
        } catch (MessagingException e) {
            e.printStackTrace();
            return error(30000, e.getMessage());
        }
    }

    @GetMapping("verify_email_code")
    public Map<String, Object> verifyEmailCode(String token, String code) {
        if (!StringUtils.hasText(token) || !StringUtils.hasText(code)) {
            return error(30000, "invalid params");
        }

        Map<String, String> queryMap = new HashMap<>();
        queryMap.put("token", token);
        Map<String, String> configMap = new HashMap<>();
        configMap.put("like", "false");
        List resultList = service.selectBaseList(service.select(queryMap, configMap));
        if (resultList.size() <= 0) {
            return error(30000, "invalid token");
        }

        CodeToken obj = (CodeToken) resultList.get(0);
        Date now = new Date();
        if (!obj.getExpire_time().after(now)) {
            return error(30000, "code expired");
        }

        if (!code.equals(obj.getCode())) {
            return error(30000, "code mismatch");
        }

        return success(1);
    }
}
