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
 * 报名信息：(RegistrationInformation)表实体类
 *
 */
@TableName("`registration_information`")
@Data
@EqualsAndHashCode(callSuper = false)
public class RegistrationInformation implements Serializable {

    // RegistrationInformation编号
    @TableId(value = "registration_information_id", type = IdType.AUTO)
    private Integer registration_information_id;

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
    // 展位名称
    @TableField(value = "`booth_name`")
    private String booth_name;
    // 展位类型
    @TableField(value = "`booth_type`")
    private String booth_type;
    // 展位价格
    @TableField(value = "`booth_prices`")
    private Double booth_prices;
    // 报名用户
    @TableField(value = "`enrolled_user`")
    private Integer enrolled_user;
    // 用户姓名
    @TableField(value = "`user_name`")
    private String user_name;
    // 用户手机
    @TableField(value = "`users_mobile_phone`")
    private String users_mobile_phone;
    // 报名人数
    @TableField(value = "`number_of_registrations`")
    private Double number_of_registrations;
    // 企业资质
    @TableField(value = "`enterprise_qualifications`")
    private String enterprise_qualifications;
    // 报名备注
    @TableField(value = "`registration_notes`")
    private String registration_notes;
    // 场地平面图
    @TableField(value = "`site_plan`")
    private String site_plan;
    // 参展文件
    @TableField(value = "`exhibitor_documents`")
    private String exhibitor_documents;





    // 审核状态
    @TableField(value = "examine_state")
    private String examine_state;

    // 支付状态
    @TableField(value = "pay_state")
    private String pay_state;

    // 支付类型: 微信、支付宝、网银
    @TableField(value = "pay_type")
    private String pay_type;

    @TableField(value = "registration_status")
    private String registration_status;

    @TableField(value = "waitlist_no")
    private Integer waitlist_no;

    @TableField(value = "waitlist_time")
    private Timestamp waitlist_time;

    @TableField(value = "confirm_time")
    private Timestamp confirm_time;

    @TableField(value = "cancel_time")
    private Timestamp cancel_time;

    // 越级状态
    @TableField(value = "escalate_state")
    private String escalate_state;

    // 越级原因
    @TableField(value = "escalate_reason")
    private String escalate_reason;

    // 审核回复
    @TableField(value = "examine_reply")
    private String examine_reply;











		// 行程确认限制次数
	@TableField(value = "travel_confirmation_limit_times")
	private String travel_confirmation_limit_times;
		// 退款申请限制次数
	@TableField(value = "refund_request_limit_times")
	private String refund_request_limit_times;
	
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
