package com.project.demo.controller;

import com.project.demo.entity.HostUser;
import com.project.demo.service.HostUserService;
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
 * 主办用户：(HostUser)表控制层
 *
 */
@RestController
@RequestMapping("/host_user")
public class HostUserController extends BaseController<HostUser, HostUserService> {

    /**
     * 主办用户对象
     */
    @Autowired
    public HostUserController(HostUserService service) {
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
        HostUser host_user = new HostUser();
            host_user.setCompany_name(paramMap.get("company_name")==null?null:String.valueOf(paramMap.get("company_name")));
                            host_user.setCompany_phone(paramMap.get("company_phone")==null?null:String.valueOf(paramMap.get("company_phone")));
                            host_user.setQualification_certificate(paramMap.get("qualification_certificate")==null?null:String.valueOf(paramMap.get("qualification_certificate")));
                        host_user.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
        host_user.setUserId(paramMap.get("user_id")==null?null:Integer.valueOf(String.valueOf(paramMap.get("user_id"))));
                                                            host_user.setCreate_by(paramMap.get("create_by")==null?null:Integer.valueOf(String.valueOf(paramMap.get("create_by"))));
        this.addEntity(host_user);
        System.out.println("主办用户新增成功");
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
        HostUser host_user = new HostUser();
            host_user.setCompany_name(paramMap.get("company_name")==null?null:String.valueOf(paramMap.get("company_name")));
                    host_user.setCompany_phone(paramMap.get("company_phone")==null?null:String.valueOf(paramMap.get("company_phone")));
                    host_user.setQualification_certificate(paramMap.get("qualification_certificate")==null?null:String.valueOf(paramMap.get("qualification_certificate")));
                host_user.setExamine_state(paramMap.get("examine_state")==null?null:String.valueOf(paramMap.get("examine_state")));
        host_user.setUserId(paramMap.get("user_id")==null?null:Integer.valueOf(String.valueOf(paramMap.get("user_id"))));
                    this.setEntity(queryMap,configMap,host_user);
        System.out.println("主办用户修改成功");
        return success(1);
    }


    /**
     * 修改审核状态
     *
     * @param id          要修改的记录ID
     * @param newState    新的审核状态
     * @return 提示信息：审核成功/失败
     */
    @Transactional
    @GetMapping("/update_examine_state")
    public String updateExamineState(Long id, String newState) throws IOException {
        // 检查传入的状态是否合法
        if (!newState.equals("未审核") && !newState.equals("已通过") && !newState.equals("未通过")) {
            return "非法的审核状态";
        }

        Map<String,String> queryMap = new HashMap<>();
        queryMap.put("id",String.valueOf(id));
        // 根据ID查找记录
        HostUser host_user = service.findOne(queryMap);

        if (host_user!=null) {
            // 更新审核状态
            host_user.setExamine_state(newState);
            this.setEntity(queryMap,new HashMap<>(),host_user);

            return "审核成功";
        } else {
            return "审核失败：记录不存在";
        }
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
        HostUser host_user = JSON.parseObject(JSON.toJSONString(registeredMap),HostUser.class);

        if (host_user != null) {
            // 查询用户附加信息
            Map<String,Object> userMap = this.getObjByMap(queryMap);
            User user = JSON.parseObject(JSON.toJSONString(userMap),User.class);

            Map<String,Object> result = new HashMap<>();
            result.put("user",user);
            result.put("host_user",host_user);
            return result;
        } else {
            throw new RuntimeException("主办用户不存在}");
        }
    }
}
