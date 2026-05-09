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
 * 退款申请：(RefundRequest)表实体类
 *
 */
@TableName("`refund_request`")
@Data
@EqualsAndHashCode(callSuper = false)
public class RefundRequest implements Serializable {

    // RefundRequest编号
    @TableId(value = "refund_request_id", type = IdType.AUTO)
    private Integer refund_request_id;

    // 订单编号
    @TableField(value = "`order_number`")
    private String order_number;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
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
    // 申请时间
    @TableField(value = "`application_time`")
    private Timestamp application_time;
    // 申请理由
    @TableField(value = "`reason_for_application`")
    private String reason_for_application;





    // 审核状态
    @TableField(value = "examine_state")
    private String examine_state;



    // 审核回复
    @TableField(value = "examine_reply")
    private String examine_reply;












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
