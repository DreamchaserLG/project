package com.project.demo.entity;

import com.alibaba.fastjson.annotation.JSONField;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.io.Serializable;
import java.sql.Timestamp;


/**
 * 普通用户：(RegularUser)表实体类
 *
 */
@TableName("`regular_user`")
@Data
@EqualsAndHashCode(callSuper = false)
public class RegularUser implements Serializable {

    // RegularUser编号
    @TableId(value = "regular_user_id", type = IdType.AUTO)
    private Integer regular_user_id;

    // 用户姓名
    @TableField(value = "`user_name`")
    private String user_name;
    // 用户手机
    @TableField(value = "`users_mobile_phone`")
    private String users_mobile_phone;









    // 用户编号
    @TableField(value = "user_id")
    private Integer userId;











			


                                        





    // 创建用户
    @TableField(value = "create_by")
    private Integer create_by;
    
	// 更新时间
    @TableField(value = "update_time")
    private Timestamp update_time;

    // 创建时间
    @TableField(value = "create_time")
    private Timestamp create_time;

}
