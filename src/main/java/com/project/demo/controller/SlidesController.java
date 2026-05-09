package com.project.demo.controller;

import com.alibaba.fastjson.JSON;
import com.project.demo.entity.Slides;
import com.project.demo.service.SlidesService;

import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Map;
import java.util.List;
import com.alibaba.fastjson.JSONObject;
import java.util.Optional;

/**
 * 轮播图：(Slides)表控制层
 */
@RestController
@RequestMapping("slides")
public class SlidesController extends BaseController<Slides, SlidesService> {
    /**
     * 服务对象
     */
    @Autowired
    public SlidesController(SlidesService service) {
        setService(service);
    }

    @PostMapping("/add")
    @Transactional
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
            Map<String, Object> addMap = service.readBody(request.getReader());
        // 验证参数是否合法
        checkParameter(addMap, "title", "标题不能为空");
        // 移除不需要的字段
        addMap.keySet().removeIf(key -> key.equals("create_time") || key.equals("update_time"));
        // 插入数据
        this.service.insert(addMap);
            System.out.println("轮播图新增成功");
        return success(1);
    }

    @PostMapping("/set")
    @Transactional
    public Map<String, Object> set(HttpServletRequest request) throws IOException {
        Map<String,Object> body = this.service.readBody(request.getReader());
        Slides slides = JSON.parseObject(JSON.toJSONString(body),Slides.class);
        this.service.updateEntity(service.readQuery(request), service.readConfig(request), slides);
        return success(1);
    }

    @RequestMapping(value = "/del")
    @Transactional
    public Map<String, Object> del(HttpServletRequest request) {
        return Optional.ofNullable(service.readQuery(request)) // 获取查询条件
                .filter(query -> !query.isEmpty()) // 校验查询条件是否为空
                .map(query -> { // 如果查询条件合法，继续执行删除逻辑
                    Map<String, String> config = service.readConfig(request); // 读取配置信息
                    this.service.delete(query, config); // 执行删除操作
                    return success(1);
                })
                .orElse(error(30000,"查询条件不能为空")); // 如果查询条件不合法，返回错误信息
    }

    @RequestMapping("/get_obj")
    public Map<String, Object> obj(HttpServletRequest request) {
        // 读取查询条件
        Map<String, String> query = service.readQuery(request);
        Map<String, String> config = service.readConfig(request);
        List resultList = service.selectBaseList(service.select(query, config));
        if (resultList.size() > 0) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("obj",resultList.get(0));
            return success(jsonObject);
        } else {
            return success(null);
        }
    }

    /**
     * 验证指定参数是否存在，如果不存在则抛出异常
     */
    private void checkParameter(Map<String, Object> map, String key, String errorMessage) {
        if (map == null || !map.containsKey(key) || map.get(key) == null) {
            throw new IllegalArgumentException(errorMessage);
        }
    }
}


