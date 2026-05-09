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
 * 主办用户：(HostUser)表实体类
 *
 */
@TableName("`host_user`")
@Data
@EqualsAndHashCode(callSuper = false)
public class HostUser implements Serializable {

    // HostUser编号
    @TableId(value = "host_user_id", type = IdType.AUTO)
    private Integer host_user_id;

    // 企业名称
    @TableField(value = "`company_name`")
    private String company_name;
    // 企业电话
    @TableField(value = "`company_phone`")
    private String company_phone;
    // 资质证明
    @TableField(value = "`qualification_certificate`")
    private String qualification_certificate;





    // 审核状态
    @TableField(value = "examine_state")
    private String examine_state;




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
