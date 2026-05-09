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
 * 行程确认：(TravelConfirmation)表实体类
 *
 */
@TableName("`travel_confirmation`")
@Data
@EqualsAndHashCode(callSuper = false)
public class TravelConfirmation implements Serializable {

    // TravelConfirmation编号
    @TableId(value = "travel_confirmation_id", type = IdType.AUTO)
    private Integer travel_confirmation_id;

    // 订单编号
    @TableField(value = "`order_number`")
    private String order_number;
    // 展位编号
    @TableField(value = "`booth_number`")
    private String booth_number;
    // 会展编号
    @TableField(value = "`exhibitionconvention_number`")
    private String exhibitionconvention_number;
    // 会展主题
    @TableField(value = "`exhibition_theme`")
    private String exhibition_theme;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
    // 报名用户
    @TableField(value = "`enrolled_user`")
    private Integer enrolled_user;
    // 用户姓名
    @TableField(value = "`user_name`")
    private String user_name;
    // 用户手机
    @TableField(value = "`users_mobile_phone`")
    private String users_mobile_phone;
    // 确认时间
    @TableField(value = "`confirm_time`")
    private Timestamp confirm_time;
    // 到场人数
    @TableField(value = "`number_of_attendees`")
    private Double number_of_attendees;




















			    // 额外信息
    @TableField(value = "extra")
    private String extra;
	// 来源表
	@TableField(value = "source_table")
	private String source_table;
	
	// 来源ID
	@TableField(value = "source_id")
	private Integer source_id;
	
	// 来源用户ID
	@TableField(value = "source_user_id")
	private Integer source_user_id;
	


                                        





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
