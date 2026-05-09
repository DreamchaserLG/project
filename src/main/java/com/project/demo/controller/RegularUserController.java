package com.project.demo.controller;

import com.project.demo.entity.RegularUser;
import com.project.demo.service.RegularUserService;
import com.alibaba.fastjson.JSON;
import com.project.demo.entity.User;
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
 * 普通用户：(RegularUser)表控制层
 *
 */
@RestController
@RequestMapping("/regular_user")
public class RegularUserController extends BaseController<RegularUser, RegularUserService> {

    /**
     * 普通用户对象
     */
    @Autowired
    public RegularUserController(RegularUserService service) {
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
        RegularUser regular_user = new RegularUser();
            regular_user.setUser_name(paramMap.get("user_name")==null?null:String.valueOf(paramMap.get("user_name")));
                            regular_user.setUsers_mobile_phone(paramMap.get("users_mobile_phone")==null?null:String.valueOf(paramMap.get("users_mobile_phone")));
                        regular_user.setUserId(paramMap.get("user_id")==null?null:Integer.valueOf(String.valueOf(paramMap.get("user_id"))));
                                                            regular_user.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(regular_user);
        System.out.println("普通用户新增成功");
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
        RegularUser regular_user = new RegularUser();
            regular_user.setUser_name(paramMap.get("user_name")==null?null:String.valueOf(paramMap.get("user_name")));
                    regular_user.setUsers_mobile_phone(paramMap.get("users_mobile_phone")==null?null:String.valueOf(paramMap.get("users_mobile_phone")));
                regular_user.setUserId(paramMap.get("user_id")==null?null:Integer.valueOf(String.valueOf(paramMap.get("user_id"))));
                    this.setEntity(queryMap,configMap,regular_user);
        System.out.println("普通用户修改成功");
        return success(1);
    }


    /**
     * 根据 user_id 查询用户及其附加表信息
     *
     * @param userId 用户ID
     * @return 包含用户信息和附加信息的对象
     */
    @GetMapping("/get_user_by_id")
    public Map<String,Object> getUserById(Long userId) {
        Map<String,String> queryMap = new HashMap<>();
        queryMap.put("user_id",String.valueOf(userId));
        // 查询用户基本信息
        Map<String,Object> registeredMap = this.getObjByMap(queryMap);
        RegularUser regular_user = JSON.parseObject(JSON.toJSONString(registeredMap),RegularUser.class);

        if (regular_user != null) {
            // 查询用户附加信息
            Map<String,Object> userMap = this.getObjByMap(queryMap);
            User user = JSON.parseObject(JSON.toJSONString(userMap),User.class);

            Map<String,Object> result = new HashMap<>();
            result.put("user",user);
            result.put("regular_user",regular_user);
            return result;
        } else {
            throw new RuntimeException("普通用户不存在}");
        }
    }
}
