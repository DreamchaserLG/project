package com.project.demo.dao;

import com.project.demo.dao.base.BaseMapper;
import com.project.demo.entity.RegularUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 普通用户：(RegularUser)Mapper接口
 *
 */
@Mapper
public interface RegularUserMapper extends BaseMapper<RegularUser>{

}
